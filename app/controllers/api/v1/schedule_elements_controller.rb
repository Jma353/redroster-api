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
	before_action :schedule_belongs_to_user, only: [:create]
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

		# Create our data 
		data = @se.valid? ? schedule_element_json(@se) : { errors: @se.errors.full_messages }

		# Render our JSON 
		render json: { success: @se.valid?, data: data } 
	end 



	## END CREATION 





	# Delete a schedule element from a specific schedule 
	def destroy
		# We have the schedule 
		@schedule_element = ScheduleElement.where(schedule_id: @schedule.id).find_by_section_num(section_params[:section_num])
		if !@schedule_element.blank?
			@schedule_element.delete
		end 
		render json: { success: !@schedule_element.blank? }
	end 






	private 


		# Schedule Element Safe Params 
		def schedule_element_params
			params[:schedule_element].present? ? params.require(:schedule_element).permit(:schedule_id, :term, :subject, :course_num, :section_num) : {} 
		end


		# Parameters necessary to creation this section as necessary 
		def section_params
			params.require(:section).permit(:term, :schedule_id, :subject, :course_num, :section_num)
		end 



end
