# == Schema Information 
# 
#  Table Name: courses 
#  
#  course_id					:integer					 	not null (THIS IS GIVEN BY CORNELL), PRIMARY KEY 
#  master_course_id 	:integer 						refers to master course 
#  term 							:string 					 	not null/blank, 4 characters 
#  subject 		 				:string 				   	not null/blank, 2 or more characters 
#  number			 				:integer 				   	not null/blank, 1000..9999 range 
#  created_at  				:datetime				   	not null
#  updated_at  				:datetime 				 	not null 



class Course < ActiveRecord::Base

	validates :course_id, presence: true 
	validates :term, presence: true, length: { minimum: 4, maximum: 4 }
	validates :subject, presence: true, length: { minimum: 2 }
	validates :number, presence: true, numericality: { greater_than_or_equal_to: 1000, less_than_or_equal_to: 9999 }
	validate :unique_class, :on => :create 

	def unique_class 
		errors.add_to_base("This course exists already") unless Course.find_by(term: self.term, subject: self.subject, number: self.number).blank?
	end 

	def sections 
		Section.where(course_id: self.id)
	end 

end
