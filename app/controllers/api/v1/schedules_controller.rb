# == Schema Information 
# 
#  Table Name: schedules
#  
#  id 								:integer 					 	not null, PRIMARY KEY 
#  user_id 						:integer					 	not null/blank 
#  term								:string 						not null/blank
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

include SchedulesHelper
class Api::V1::SchedulesController < Api::V1::ApplicationController

	# To get a test user to associate this schedule with 
	before_action :grab_test_user 
	before_action :schedule_belongs_to_user, only: [:show] # in ApplicationController 



	# Schedule creation endpoint 
	def create
		result = schedule_params.merge!({ user_id: @user.id })
		s = Schedule.create(result)
		render json: { success: s.valid? }
	end 



	# Endpoint to show a full schedule JSON to be parsed on iOS frontend for viewing schedules
	def show 
		# have @schedule I care about 
		result = []
		@schedule_elements = ScheduleElement.where(schedule_id: @schedule.id)
		section_nums = @schedule_elements.map { |se| se.section_num }
		@sections = section_nums.map { |n| Section.find_by_section_num(n) }

		@sections.each do |s| 
			sec = schedule_section(s)
			result.push(sec)
		end 
		
		render json: { success: true, data: { schedule: result } } 

	end 



	# Schedule deletion endpoint 
	def destroy
		s = Schedule.where(user_id: @user.id).find_by_id(params[:schedule_id])
		unless s.blank? 
			ScheduleElement.where(schedule_id: s.id).each do |se| 
				se.delete 
			end 
			s.delete 
		end 
		render json: { success: !s.blank? }
	end 

	private 

		def schedule_params 
			params.require(:schedule).permit(:user_id, :term)
		end 



end
