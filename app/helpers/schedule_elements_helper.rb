module ScheduleElementsHelper


	# Check to see if a section exists amongst a list of sections provided by the Cornell Courses API 
	def section_details(sections, desired_num)
		sections.each do |s| 
			if s["classNbr"] == desired_num
				# Return: [type, startTime, endTime, pattern]
				p s
				p s["meetings"][0]["timeStart"]
				p s["meetings"][0]["timeEnd"]
				return s["ssrComponent"], s["meetings"][0]["timeStart"], s["meetings"][0]["timeEnd"], s["meetings"][0]["pattern"]
			end 
		end 
		return nil
	end 



end
