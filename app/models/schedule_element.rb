# == Schema Information 
# 
#  Table Name: schedule_elements
# 
#  PRIMARY KEY: (schedule_id, section_id)
# 
#  schedule_id 				:integer 						not null
#  section_id 				:integer						not null
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

class ScheduleElement < ActiveRecord::Base

	# Must be validated b/c they make up the primary key 
	validates :schedule_id, presence: true
	validates :section_id, presence: true 
	# Must be validated to ensure the above are relevant 
	validate :schedule_exists, :on => :create 
	validate :section_exists, :on => :create 
	validate :no_section_collision, :on => :create 


	def schedule_exists 
		errors.add(:schedule_id, "This schedule does not exist") unless !Schedule.find_by_id(self.schedule_id)
	end 

	def section_exists 
		errors.add(:section_id, "This section does not exist") unless !Section.find_by_id(self.section_id)
	end 


	# Checks to see if this schedule has a conflicting section that clashes with this one in identity 
	# E.g. If one tries to add two CS 1110 lectures at different times to their schedule 
	def no_section_collision 
		schedule_peers = ScheduleElement.where(schedule_id: self.schedule_id)
		section = Section.find_by_id(self.section_id)
		schedule_peers.each do |se| 	
			peer_section = Section.find_by_id(se.section_id)
			if (peer_section.course_id == section.course_id) && (peer_section.type == section.type) 
				errors.add(:section_id, "Another section exists that is of the same type and course as this one") unless section.type == "DIS"
			end 
		end 
	end 


end


