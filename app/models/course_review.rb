# == Schema Information 
# 
#  Table Name: course_reviews 
#  
#  id 								:integer 					 	not null, PRIMARY KEY 
#  course_id 					:integer 						not null/blank
#  title							:integer 						
#  feedback						:text 			
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 



class CourseReview < ActiveRecord::Base

	validates :course_id, presence: true 
	belongs_to :course 

	

end
