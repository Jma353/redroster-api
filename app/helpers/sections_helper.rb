# == Schema Information
#
# Table name: sections
#
#  section_num  :integer          not null, primary key
#  course_id    :integer
#  section_type :string
#  start_time   :string
#  end_time     :string
#  day_pattern  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

module SectionsHelper
	require 'date'

	# From a string time in the format "HH:MM(AM/PM)", obtain minute integer 
	def min_int(time_string)
		i = time_string.index(/[A-Za-z]/)
		colon = time_string.index(":")
		min_string = time_string[(colon+1)...i]
		Integer((min_string[0] == "0" ? min_string[1] : min_string))
	end 


	# From a string time in the format "HH:MM(AM/PM)", obtain the military-hour integer 
	def hour_int(time_string)
		hour_string = time_string[0...(start_time.index(":"))]
		am_or_pm = time_string[(time_string.index(/[A-Za-z]/))..-1]
		Integer((hour_string[0] == "0" ? hour_string[1] : hour_string)) + (am_or_pm.upcase == "PM" ? 12 : 0)
	end


	def time_between?(h, m, s)	
		s1_time = Time.local(2016, 1, 1, h, m, 0)
		s2_start = Time.local(2016, 1, 1, s.start_hour, s.start_mins, 0)
		s2_end = Time.local(2016, 1, 1, s.end_hour, s.end_mins, 0)

		(s2_start..s2_end).cover? s1_time
	end 


end
