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
		crse_ids = []  
		s.schedule_elements.each do |se| 
			schedule_conflict = se.collision || schedule_conflict 
			crse_id = se.section.course.crse_id.to_s
			element_ag[crse_id] = element_ag[crse_id].blank? ? [] : element_ag[crse_id] 
			crse_ids = crse_ids | [crse_id]
			element_ag[crse_id] << se 
		end 

		# Build list of courses covered by this schedule 
		courses = { "courses" => [] }
		max_creds = 0
		min_creds = 0 
		crse_ids.each do |ci| 
			course_json = CourseSerializer.new(Course.find_by({ crse_id: ci.to_i, term: s.term })).as_json
			schedule_elements = element_ag[ci]
			s_e_jsons = schedule_elements.map { |se| ScheduleElementSerializer.new(se).as_json }
			course_json["schedule_elements"] = s_e_jsons

			# Sub in new course name 
			course_json["course"]["subject"] = element_ag[ci][0].subject 
			course_json["course"]["catalog_number"] = element_ag[ci][0].catalog_number

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
			deactivate_other_schedules(s)
		end 

		return schedule_json
	end 


	# Make this schedule active and make all other schedules of the same term / user inactive 
	def make_schedule_active(s)
		deactivate_other_schedules(s)
		s.update_attributes({ is_active: true })
	end 


	# Deactivate other schedules 
	def deactivate_other_schedules(s)
		other_schedules = Schedule.where("user_id = ? AND term = ? AND id != ?", s.user_id, s.term, s.id)
		other_schedules.each do |sched| 
			sched.update_attributes({ is_active: false })
		end 
	end 


	# Get all the schedules own by a user 
	def user_schedules(u)
		schedules = { "user" => UserSerializer.new(u).as_json["user"], "schedules" => [] } 
		u.schedules.each { |s| schedules["schedules"] << schedule_json(s) }
		schedules 
	end 


end
