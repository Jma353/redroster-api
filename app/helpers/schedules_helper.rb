module SchedulesHelper
	require 'net/http'
	require 'json'

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



end
