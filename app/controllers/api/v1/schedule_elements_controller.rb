# == Schema Information 
# 
#  Table Name: schedule_elements
# 
#  PRIMARY KEY: (schedule_id, section_num)
# 
#  schedule_id 				:integer 						not null
#  section_num 				:integer						not null 
#  collision 					:boolean 						not null (set based on time collisions with other schedule elements)
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

include ScheduleElementsHelper 
class Api::V1::ScheduleElementsController < Api::V1::ApplicationController
	
	# To get the user themself 
	# before_action :grab_test_user 
	before_action :google_auth

	# Used to validate creation
	before_action :schedule_belongs_to_user, only: [:create, :destroy]
	before_action :proper_term, only: [:create]



  # Check to see if the schedule exists/belongs to the user  (used in specific subclasses)
  def schedule_belongs_to_user
  	@schedule = Schedule.find_by(id: schedule_element_params[:schedule_id], user_id: @user.id)
    if @schedule.blank? 
      render json: { success: false, data: { errors: ["This schedule either doesn't exist or doesn't belong to you"] } }
    else 
      @schedule
    end 
  end 

  


  # Cascading validations for creation
  def proper_term 
  	if schedule_element_params[:term] != @schedule.term
  		render json: { success: false, data: { errors: ["This schedule's term does not match the desired course's term"]}} and return 
  	end 
  	@schedule
  end 





  # Create a schedule element and load the DB accordingly 
	def create 	
		# List of sections
		sections = schedule_element_params[:section_num]
		# schedule_elements 
		schedule_elmts = [] 
		# [CS1110_LEC, CS1110_DIS].each do .. 
		sections.each do |sn| 

			# `response` b/c could return an error json 
			section_response = get_or_create_section(schedule_element_params.merge({ section_num: sn }))

			# Will only be true if the response is an error hash
			if section_response[:success] == false
				render json: section_response and return 
			end

			# Else, we know section is valid, unless collision or something 
			@se = @schedule.schedule_elements.create(section_num: section_response.section_num)

			# If this is valid and saves, we need to update all attributes to reflect this
			if @se.valid? 
				@schedule.schedule_elements.each do |se|
					se.update_attributes(collision: se.collisions?)
				end 
			end

			# Create our data 
			data = @se.valid? ? schedule_element_json(@se) : { errors: @se.errors.full_messages }

			# If invalid, render the issue 
			if !@se.valid?  
				render json: { success: false, data: data } and return 
			else # If not an issue, add to the list 
				schedule_elmts << data["schedule_element"]
			end 

		end 

		# Render our JSON (at this point, it would be true)
		render json: { success: true, data: { schedule_elements: schedule_elmts } }

	end 

	## END CREATION 





	# Delete a schedule element from a specific schedule 
	def destroy
		@schedule_element = ScheduleElement.destroy_all(schedule_id: @schedule.id, id: schedule_element_params[:id])
		if !@schedule_element.blank?
			@schedule.schedule_elements.each do |se|
				se.update_attributes(collision: se.collisions?)
			end 
		end 
		render json: { success: !@schedule_element.blank? }
	end 





	private 

		# Schedule Element Safe Params 
		def schedule_element_params(extra={})
			if params[:schedule_element].present? 
				params[:schedule_element][:section_num] ||= [] # To ensure array structure
				params.require(:schedule_element).permit(:id, :schedule_id, :term, :subject, :course_num, section_num: []).merge(extra) 
			else 
				{} 
			end 
		end



end



