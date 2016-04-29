# == Schema Information 
# 
#  Table Name: sections 
#  
#  section_num 				:integer					 	not null, PRIMARY KEY 
#  course_id	 				:integer					 	not null/blank 
#  section_type				:string 						not null/blank
#  start_time 				:string							not null/blank
#  end_time						:string 						not null/blank
#  day_pattern 				:string 						not null/blank
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

include SectionsHelper 
class Section < ActiveRecord::Base
	# References 
	belongs_to :course, class_name: "Course", foreign_key: "course_id"
	has_many :schedule_elements, class_name: "ScheduleElement"


	# Validations 
	validates :section_num, presence: true, uniqueness: true 
	validates :course_id, presence: true 
	validates :section_type, presence: true, length: { minimum: 3, maximum: 4 }
	validates :start_time, presence: true 
	validates :end_time, presence: true 
	validates :day_pattern, presence: true 
	validate :course_exists, :on => :create 

	def course_exists 
		errors.add_to_base("This course does not exist.") unless !Course.find_by_course_id(self.course_id).blank? 
	end 	

	# Section time information 

	def start_hour 
		hour_int(self.start_time)
	end

	def end_hour 
		hour_int(self.end_time)
	end 

	def start_mins 
		min_int(self.start_time)
	end 

	def end_mins 
		min_int(self.end_time)
	end 


	# Method to test collision with another section 
	def collides?(section)
		same_dates = self.day_pattern.include?(section.day_pattern) || (section.day_pattern.include? self.day_pattern)
		self_start_between = time_between?(self.start_hour, self.start_mins, section)
		self_end_between = time_between?(self.end_hour, self.end_mins, section)

		section_start_between = time_between?(section.start_hour, section.start_mins, self)
		section_end_between = time_between?(section.end_hour, section.end_mins, self)

		both_contained = (section_start_between && section_end_between) || (self_start_between && self_end_between)

		return same_dates && (both_contained || self_start_between || self_end_between)

	end 


	# For accessing Course info 

	def course 
		Course.find_by_course_id(self.course_id)
	end

	def course_term
		course.term
	end 

	def course_subject
		course.subject
	end 
	
	def course_num
		course.number 
	end 





end
