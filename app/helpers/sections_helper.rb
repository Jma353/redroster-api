module SectionsHelper


	# From a string time in the format "HH:MM(AM/PM)", obtain minute integer 
	def min_int(time_string)
		i = time_string.index(/[A-Za-z]/)
		colon = time_string.index(":")
		min_string = time_string[(colon+1)...i]
		Integer(min_string)
	end 


	# From a string time in the format "HH:MM(AM/PM)", obtain the military-hour integer 
	def hour_int(time_string)
		hour_string = time_string[0...(start_time.index(":"))]
		am_or_pm = time_string[(time_string.index(/[A-Za-z]/))..-1]
		Integer(hour_string) + (am_or_pm.upcase == "PM" ? 12 : 0)
	end


end
