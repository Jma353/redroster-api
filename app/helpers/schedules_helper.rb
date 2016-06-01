# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  term       :string
#  name       :string
#  is_active  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module SchedulesHelper
	require 'net/http'
	require 'json'

	# Method to construct a proper schedule JSON 
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

		# Build list of courses covered by this schedule 
		courses = { "courses" => [] }
		max_creds = 0
		min_creds = 0 
		course_ids.each do |ci| 
			# Get the course_json 
			course_json = CourseSerializer.new(Course.find_by_course_id(ci.to_i)).as_json
			schedule_elements = element_ag[ci]
			s_e_jsons = schedule_elements.map { |se| ScheduleElementSerializer.new(se).as_json }
			course_json["schedule_elements"] = s_e_jsons
			courses["courses"] << course_json

			max_creds += course_json["course"][:credits_maximum]
			min_creds += course_json["course"][:credits_minimum]
		end 

		schedule_json = ScheduleSerializer.new(s).as_json

		# Merge in stuff 
		schedule_json["schedule"].merge!({ schedule_conflict: schedule_conflict })
		schedule_json["schedule"].merge!(courses).merge!({max_sched_credits: max_creds, min_sched_credits: min_creds })

		# Update all other schedules of this user 
		# to indicate that they are no longer active 
		if schedule_json["schedule"][:is_active] 
			other_schedules = Schedule.where("user_id = ? AND term = ? AND id != ?", s.user_id, s.term, s.id)
			other_schedules.each do |s| 
				s.update_attributes({ is_active: false })
			end 
		end 

		return schedule_json
	end 


	# Get all the schedules own by a user 
	def user_schedules(u)
		schedules = { "schedules" => [] } 
		u.schedules.each { |s| schedules["schedules"] << schedule_json(s) }
		schedules 
	end 



end
