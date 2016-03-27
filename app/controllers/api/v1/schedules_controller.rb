# == Schema Information 
# 
#  Table Name: schedules
#  
#  id 								:integer 					 	not null, PRIMARY KEY 
#  user_id 						:integer					 	not null/blank 
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

class Api::V1::SchedulesController < Api::V1::ApplicationController

	# To get a test user to associate this schedule with 
	before_action :grab_test_user 

	# Schedule creation endpoint 
	def create
		s = Schedule.create(user_id: @user.id)
		render json: { success: s.valid? }
	end 

	def destroy
		s = Schedule.where(user_id: @user.id).find_by_id(params[:schedule_id])
		unless s.blank? 
			s.delete 
		end 
		render json: { success: !s.blank? }
	end 


end
