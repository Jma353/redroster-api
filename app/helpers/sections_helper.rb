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

module SectionsHelper
	require 'date'

	# Build the sections for a course, given the classSections 
	# array returned by the Cornell Courses API 
	# 	c: classSections array 
	def build_sections(c, course, i)
		@sections = c.map { |s| build_section(s, course, i) }
	end 


	# Helper method, build a section, given the single classSection
	# element of the classSections array returned by the Cornell 
	# Courses API
	# 	c: classSection element 
	def build_section(c, course, i) 
		# JSON needed to build the section 
		meetings_info = c["meetings"].length > 0 ? ({ start_time: c["meetings"][0]["timeStart"], 
			end_time: c["meetings"][0]["timeEnd"], 
			day_pattern: c["meetings"][0]["pattern"], 
			long_location: c["meetings"][0]["facilityDescr"], 
			topic_description: c["topicDescription"]
		}) : ({})
		build_json = {
			section_num: c["classNbr"], 
			section_type: c["ssrComponent"], 
			class_number: c["section"],
			enroll_group: i
		}.merge(meetings_info)
		# Find or create these sections 
		course.sections.find_or_create_by(build_json)
	end 


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
		((hour_string[0] == "0" ? hour_string[1] : hour_string).to_i % 12) + (am_or_pm.upcase == "PM" ? 12 : 0)
	end

	# Time between two sections 
	def time_between?(h, m, s)	
		s1_time = Time.local(2016, 1, 1, h, m, 0)
		s2_start = Time.local(2016, 1, 1, s.start_hour, s.start_mins, 0)
		s2_end = Time.local(2016, 1, 1, s.end_hour, s.end_mins, 0)

		(s2_start..s2_end).cover? s1_time
	end 


	# Make section JSON 
	def section_json(s) 
		SectionSerializer.new(s).as_json
	end 


end





