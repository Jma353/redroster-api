# == Schema Information
#
# Table name: schedule_elements
#
#  id          :integer          not null, primary key
#  schedule_id :integer
#  section_id  :integer
#  collision   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Api::V1::ScheduleElementsController < Api::V1::AuthsController
include ScheduleElementsHelper 
include SchedulesHelper


	## BEGIN CREATION 

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
		# Attempt to find the course 
		@course = Course.find_by(crse_id: schedule_element_params[:crse_id], 
			term: schedule_element_params[:term])

		# If the course is blank, make the course + all sections 
		if @course.blank? 
			# Grab required creds to retrieve course_info fom Cornell Courses API 
			term = schedule_element_params[:term]
			subject = schedule_element_params[:subject]
			number = schedule_element_params[:number]
			course_info = get_course_info(term, subject, number)
			@course = build_course_and_sections(course_info, term)
		end 

		# [CS1110_LEC, CS1110_DIS].each do .. 
		sections.each do |sn| 
			# Pulls the desired section from the 
			@section = Section.find_by(course_id: @course.id, section_num: sn)
			
			# If this section doesn't exist, the number is wrong b/c it should exist if the @course exists 
			if @section.blank? 
				render json: { success: false, data: { errors: ["This section does not exist within this course"] }} and return 
			end 

			# Else, we know section is valid, unless collision or something 
			@se = @schedule.schedule_elements.create(section_id: @section.id)

			# If this is valid and saves, we need to update all attributes to reflect this
			if @se.valid? 
				update_se_collisions(@schedule)
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
		render json: { success: true, data: schedule_json(@schedule) }

	end 



	# Delete a schedule element from a specific schedule 
	def destroy
		@schedule_element = ScheduleElement.destroy_all(schedule_id: @schedule.id, id: schedule_element_params[:id])
		if !@schedule_element.blank?
			update_se_collisions(@schedule)
		end 
		render json: { success: !@schedule_element.blank?, data: schedule_json(@schedule) }
	end 


	private 

		# Schedule Element Safe Params 
		def schedule_element_params(extra={})
			if params[:schedule_element].present? 
				params[:schedule_element][:section_num] ||= [] # To ensure array structure
				params.require(:schedule_element).permit(:id, :schedule_id, :term, :crse_id, :subject, :number, section_num: []).merge(extra) 
			else 
				{} 
			end 
		end



end



