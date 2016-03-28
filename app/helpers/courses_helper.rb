module CoursesHelper

	def format_course(c)
		course_json = { 
										id: c["crseId"], # 123456, unique
										subject: c["subject"], # CS, ORIE, etc. 
										catalog_number: c["catalogNbr"], # 1110, 4999, etc. 
										title_short: c["titleShort"], # Shorter title 
										title_long: c["titleLong"], # Longer title 
										description: c["description"], # Description of course 
										credits_minimum: c["enrollGroups"][0]["unitsMinimum"], # minimum units of this course 
										credits_maximum: c["enrollGroups"][0]["unitsMaximum"], # maximum units of this course 
										required_sections: c["enrollGroups"][0]["componentsRequired"], # components required (e.g. LEC, DIS, etc.)
										begin_date: c["enrollGroups"][0]["sessionBeginDt"], # begin date 
										end_date: c["enrollGroups"][0]["sessionEndDt"], # end data 
									 }
		course_json
	end 

	def format_course_less(c)
		course_json = {
										id: c["crseId"], # 123456, unique
										subject: c["subject"], # CS, ORIE, etc. 
										catalog_number: c["catalogNbr"], # 1110, 4999, etc. 
										title_short: c["titleShort"], # Shorter title 
										title_long: c["titleLong"], # Longer title 
										description: c["description"], # Description of course 
									 }
	end 


	# Method to curate courses based upon the number that has been given in the query 
	def num_compare(num, c)
		return true if num == nil # if no number was provided 
		course_num = Integer(c["catalogNbr"])
		div = 1000 
		while(div > 0) do 
			if num == course_num/div
				return true 
			end 
			div = div/10 
		end 
		return false 
	end 


end
