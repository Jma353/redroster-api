# == Schema Information
#
# Table name: schedule_elements
#
#  id          :integer          not null, primary key
#  schedule_id :integer
#  section_num :integer
#  collision   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'net/http'
require 'json'

module ScheduleElementsHelper
include CoursesHelper 
include ApplicationHelper

	# Check to see if a section exists amongst a list of sections provided by the Cornell Courses API 
	def section_details(sections, desired_num)
		sections.each do |s| 
			if s["classNbr"].to_i == desired_num.to_i
				# Return: [type, startTime, endTime, pattern]
				return s["ssrComponent"], s["meetings"][0]["timeStart"], s["meetings"][0]["timeEnd"], s["meetings"][0]["pattern"]
			end 
		end 
		return false
	end 	



	# Get or create a course section 
	def get_or_create_section(params)

		# Attempts to find the section 
		@section = Section.find_by_section_num(params[:section_num]) 

		# If the section was not found in the DB 
		if @section.blank?

			# Grab all the terms for the search query 
			term = params[:term]
			subject = params[:subject]
			course_num = params[:course_num].to_i
			course_level = (course_num / 1000) * 1000 
			section_num = params[:section_num]

			# Format them into a URL string + make a request to Cornell API 
			url_string = "https://classes.cornell.edu/api/2.0/search/classes.json?roster=#{term}&subject=#{subject}&classLevels[]=#{course_level}"
			uri = URI(url_string)
			res_json = JSON.parse(Net::HTTP.get(uri))

			# Check to see if the request was successful and that the course actually exists amongst the response
			if res_json["status"] != "success" && (find_course_index(res_json, course_num) == -1)
				return { success: false, data: { errors: ["Your requested section credentials match no courses"]}}
			else 

				# Find the course's index in the response
				c_index = find_course_index(res_json, course_num)

				# Get the course's overall info 
				course_info = res_json["data"]["classes"][c_index]

				# Get or create the desired course (which could cascade and make the master_course too)
				@course = get_or_create_course(course_info, term, subject, course_num)

				# Get section info 
				sections = course_info["enrollGroups"][0]["classSections"]

				# Get the section details 
				section_dets = section_details(sections, section_num)

				if section_dets.blank? || section_dets == false
					return { success: false, data: { errors: ["This section does not exist with within this term and course"] }} 
				end 



				# Instantiate the section 
				@section = @course.sections.create(section_num: section_num.to_i, section_type: section_dets[0], 
																						start_time: section_dets[1], end_time: section_dets[2], 
																						day_pattern: section_dets[3])

			end
		end 

		@section
	end 




	## SEARCH METHODS 


	# Finds a master_course from a series of cross_listings, or returns nil 
	# if it's not found 
	def find_master_course(cross_listings)
		cross_listings.each do |cl|
			mc = MasterCourse.find_by(subject: cl[:subject], number: cl[:number])
			if !mc.blank? 		
				return mc 
			end  
		end 
		return nil 
	end





	## SERIALIZATION 


	def schedule_element_json(se) 
		ScheduleElementSerializer.new(se).as_json
	end 



end



