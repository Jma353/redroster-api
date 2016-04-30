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
	before_action :grab_test_user 

	# Used to validate creation
	before_action :schedule_belongs_to_user, only: [:create, :destroy]
	before_action :proper_term, only: [:create]



	## CREATION 

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

		# `response` b/c could return an error json 
		section_response = get_or_create_section(schedule_element_params)

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

		# Render our JSON 
		render json: { success: @se.valid?, data: data } 
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
		def schedule_element_params
			params[:schedule_element].present? ? params.require(:schedule_element).permit(:id, :schedule_id, :term, :subject, :course_num, :section_num) : {} 
		end



end



