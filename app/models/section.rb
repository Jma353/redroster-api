# == Schema Information
#
# Table name: sections
#
#  id            :integer          not null, primary key
#  section_num   :integer
#  course_id     :integer
#  section_type  :string
#  start_time    :string
#  end_time      :string
#  day_pattern   :string
#  class_number  :string
#  long_location :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

include SectionsHelper 
class Section < ActiveRecord::Base

	# References 
	belongs_to :course, class_name: "Course", foreign_key: "course_id"
	has_many :schedule_elements, class_name: "ScheduleElement", foreign_key: "section_id", :dependent => :destroy

	# Validations 
	validates :section_num, presence: true
	validates :section_num, uniqueness: { scope: [:course_id] }
	validates :course_id, presence: true 
	validates :section_type, presence: true
	# validates :start_time, presence: true 
	# validates :end_time, presence: true 
	# validates :day_pattern, presence: true 
	validate :course_exists, :on => :create 

	def course_exists 
		errors[:base] << ("This course does not exist.") unless !Course.find_by_id(self.course_id).blank? 
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
		# If it's some weird course without a meeting time yet 
		if (self.start_time.blank? || self.end_time.blank? || 
			self.day_pattern.blank? || section.start_time.blank? || 
			section.end_time.blank? || section.day_pattern.blank?)
			return false
		else 
			same_dates = self.day_pattern.include?(section.day_pattern) || (section.day_pattern.include? self.day_pattern)
			self_start_between = time_between?(self.start_hour, self.start_mins, section)
			self_end_between = time_between?(self.end_hour, self.end_mins, section)

			section_start_between = time_between?(section.start_hour, section.start_mins, self)
			section_end_between = time_between?(section.end_hour, section.end_mins, self)

			both_contained = (section_start_between && section_end_between) || (self_start_between && self_end_between)

			return same_dates && (both_contained || self_start_between || self_end_between)
		end 

	end 

	# Course info 

	def course 
		Course.find_by_id(self.course_id)
	end

	def course_term
		course.term
	end 


end
