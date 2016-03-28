module ScheduleElementsHelper


	# Check to see if a section exists amongst a list of sections provided by the Cornell Courses API 
	def section_type(sections, desired_num)
		sections.each do |s| 
			if s["classNbr"] == desired_num
				return s["ssrComponent"] # LEC, DIS, etc. 
			end 
		end 
		return nil
	end 

	

end
