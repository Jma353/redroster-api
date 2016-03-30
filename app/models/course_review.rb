# == Schema Information 
# 
#  Table Name: course_reviews 
#  
#  id 								:integer 					 	not null, PRIMARY KEY 
#  master_course_id 	:integer 						not null/blank
#  user_id 						:integer 						not null/blank
#  term								:string 						
#  lecture						:integer						1..10
#  office_hours 			:integer 						1..10 
#  difficulty					:integer 						1..10 
#  material						:integer 						1..10 
#  feedback						:text 			
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 


class CourseReview < ActiveRecord::Base

	validates :master_course_id, presence: true 
	validates :user_id, presence: true
	validates :lecture, allow_blank: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
	validates :office_hours, allow_blank: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
	validates :difficulty, allow_blank: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
	validates :material, allow_blank: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
	validates	:feedback, allow_blank: true, length: { maximum: 200 } # => max 200 character feedback 

	belongs_to :master_course
	belongs_to :user 
	validate :user_has_not_reviewed, :on => :create 

	def user_has_not_reviewed 
		c = CourseReview.where(master_course_id: self.master_course_id).find_by_user_id(self.user_id)
		errors.add_to_base("You have already reviewed this course") unless c.blank? 
	end 

	


end
