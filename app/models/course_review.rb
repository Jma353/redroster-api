# == Schema Information 
# 
#  Table Name: course_reviews 
#  
#  id 								:integer 					 	not null, PRIMARY KEY 
#  master_course_id 	:integer 						not null/blank
#  user_id 						:integer 						not null/blank				
#  feedback						:text 			
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 


class CourseReview < ActiveRecord::Base

	validates :master_course_id, presence: true 
	validates :user_id, presence: true
	belongs_to :master_course
	belongs_to :user 
	validate :user_has_not_reviewed, :on => :create 

	def user_has_not_reviewed 
		c = CourseReview.where(master_course_id: self.master_course_id).find_by_user_id(self.user_id)
		errors.add_to_base("You have already reviewed this course") unless c.blank? 
	end 


end
