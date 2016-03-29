# == Schema Information 
# 
#  Table Name: schedules
#  
#  id 								:integer 					 	not null, PRIMARY KEY 
#  user_id 						:integer					 	not null/blank 
#  term								:string 						not null/blank
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 


class Schedule < ActiveRecord::Base

	validates :user_id, presence: true 
	validates :term, presence: true 
	validate :user_exists, :on => :create 


	def user_exists 
		errors.add_to_base("This user does not exist") unless !User.find_by_id(self.user_id).blank? 
	end 

	def schedule_elements 
		ScheduleElement.where(schedule_id: self.id)
	end 


end
