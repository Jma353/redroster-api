# == Schema Information 
# 
#  Table Name: sections 
#  
#  section_num 				:integer					 	not null, PRIMARY KEY 
#  course_id	 				:integer					 	not null/blank 
#  section_type				:string 						not null/blank
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

class Section < ActiveRecord::Base

	validates :section_num, presence: true, uniqueness: true 
	validates :course_id, presence: true 
	validates :section_type, presence: true, length: { minimum: 3, maximum: 4 }
	validate :course_exists, :on => :create 

	def course_exists 
		errors.add(:course_id, "This course does not exist.") unless !Course.find_by_course_id(self.course_id).blank? 
	end 	


end
