# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  term       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module SchedulesHelper
	require 'net/http'
	require 'json'


	# Deprecated (opted for serializers -- they're more modular)
	def schedule_section(section)
		course = section.course
		term = course.term 
		subject = course.subject
		number = course.number
		uri = URI("https://classes.cornell.edu/api/2.0/search/classes.json?roster=#{term}&subject=#{subject}&q=#{number}")
		section_json = JSON.parse(Net::HTTP.get(uri))
		result = { term: term, subject: subject, number: number, section: nil }
		if section_json["status"] != "error"
			section_json = section_json["data"]["classes"][0]["enrollGroups"][0]["classSections"]
			section_json.each do |s| 
				p section.section_num
				if s["classNbr"] == section.section_num
					result[:section] = s 
					return result 
				end 
			end 
		end 
		result
	end
	


	def schedule_json(s)
		schedule_conflict = false 
		s.schedule_elements.each { |se| schedule_conflict = se.collision || schedule_conflict }
		schedule_json = ScheduleSerializer.new(s).as_json
		schedule_json["schedule"].merge!({ schedule_conflict: schedule_conflict })
		return schedule_json
	end 




end
