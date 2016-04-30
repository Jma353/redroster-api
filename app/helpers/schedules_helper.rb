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


	def schedule_json(s)
		# Initial bool value 
		schedule_conflict = false
		# Tracking courses by course_id 
		element_ag = {} 
		course_ids = [] 
		# Go through schedule_elements 
		s.schedule_elements.each do |se| 
			# Update the bool 
			schedule_conflict = se.collision || schedule_conflict 
			# Obtain the course_id in string form
			course_id = se.section.course.course_id.to_s
			# Add se to namespace of the course_id and to the course_ids list 
			element_ag[course_id] = element_ag[course_id].blank? ? [] : element_ag[course_id] 
			course_ids = course_ids | [course_id]
			element_ag[course_id] << se 
		end 

		courses = { "courses" => [] }
		course_ids.each do |ci| 
			# Get the course_json 
			course_json = CourseSerializer.new(Course.find_by_course_id(ci.to_i)).as_json
			schedule_elements = element_ag[ci]
			s_e_jsons = schedule_elements.map { |se| ScheduleElementSerializer.new(se).as_json }
			course_json["schedule_elements"] = s_e_jsons
			courses["courses"] << course_json
		end 

		schedule_json = ScheduleSerializer.new(s).as_json
		schedule_json["schedule"].merge!({ schedule_conflict: schedule_conflict })
		schedule_json.merge!(courses)
		return schedule_json
	end 




end
