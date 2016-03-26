# == Schema Information 
# 
#  Table Name: sections 
#  
#  section_num 				:integer					 	not null, PRIMARY KEY 
#  course_id	 				:integer					 	not null/blank 
#  type								:string 						not null/blank
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

class Section < ActiveRecord::Base

	validates :section_num, presence: true, uniqueness: true 
	validates :course_id, presence: true 
	validates :type, presence: true, length: { minimum: 3, maximum: 4 }
	validate :course_exists, :on => :create 


	# Theoretically, if we were to add a section for a course that we have not yet saved, 
	# we would save the course FIRST, then the section 
	def course_exists 	
		errors.add(:course_id, "This course does not exist") unless !Course.find_by_id(self.course_id).blank? 
	end 


	
	

end
