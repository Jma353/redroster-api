# == Schema Information
#
# Table name: schedule_elements
#
#  schedule_id :integer          not null, primary key
#  section_num :integer          not null
#  collision   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ScheduleElement < ActiveRecord::Base
	# References 
	belongs_to :schedule, class_name: "Schedule", foreign_key: "schedule_id"
	belongs_to :section, class_name: "Section", foreign_key: "section_num"

		# Must be validated b/c they make up the primary key 
		validates :schedule_id, presence: true
		validates :section_num, presence: true 
		validate :no_section_collision, :on => :create 
			
			
	before_create :check_collisions


	# Checks to see if this schedule has a conflicting section that clashes with this one in identity 
	# E.g. If one tries to add two CS 1110 lectures at different times to their schedule 
	def no_section_collision 
		schedule_peers = ScheduleElement.where(schedule_id: self.schedule_id)
		section = Section.find_by_section_num(self.section_num)
		schedule_peers.each do |se| 	
			peer_section = Section.find_by_section_num(se.section_num)
			if (peer_section.course_id == section.course_id) && (peer_section.section_type == section.section_type) 
				errors[:base] << ("Another section exists that is of the same type and course as this one") unless section.section_type == "DIS"
			end 
		end 
	end 


	# Fill the `collision` field on creation in a way that utilizes appropriate logic 
	def check_collisions
		schedule_peers = ScheduleElement.where(schedule_id: self.schedule_id)
		section = Section.find_by_section_num(self.section_num)
		schedule_peers.each do |se|
			peer_section = Section.find_by_section_num(se.section_num)
			if section.collides?(peer_section)
				self.collision = true 
				return 
			end 
		end 

		self.collision = false 
		return 
	end 



end


