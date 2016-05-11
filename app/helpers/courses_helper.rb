# == Schema Information
#
# Table name: courses
#
#  course_id        :integer          not null, primary key
#  master_course_id :integer
#  term             :string
#  subject          :string
#  number           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

module CoursesHelper
	include ApplicationHelper 
	require 'net/http'
  require 'json'


	def format_course(c, term)

		course_json = { 
			id: c["crseId"], # 123456, unique
			subject: c["subject"], # CS, ORIE, etc. 
			catalog_number: c["catalogNbr"], # 1110, 4999, etc. 
			title_short: c["titleShort"], # Shorter title 
			title_long: c["titleLong"], # Longer title 
			description: c["description"], # Description of course 
			prerequisites: c["catalogPrereqCoreq"], # Prereqs 
			credits_minimum: c["enrollGroups"][0]["unitsMinimum"], # minimum units of this course 
			credits_maximum: c["enrollGroups"][0]["unitsMaximum"], # maximum units of this course 
			required_sections: c["enrollGroups"][0]["componentsRequired"], # components required (e.g. LEC, DIS, etc.)
			begin_date: c["enrollGroups"][0]["sessionBeginDt"], # begin date 
			end_date: c["enrollGroups"][0]["sessionEndDt"], # end data 
			grading_basis: c["enrollGroups"][0]["gradingBasis"], # OPT or SUS
			cross_listings: c["enrollGroups"][0]["simpleCombinations"] # Crosslistings 
		}

		# Get db course info here (logic in ScheduleElementsHelper)
		@course = get_or_create_course(c, term, course_json[:subject], course_json[:catalog_number])
		
		# Create a field for users in this course 
		course_json[:people_in_course] = @course.users 

		# Return the course info 
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


	# Get a list of subjects 
	def query_subjects(term, query)
		uri = URI("https://classes.cornell.edu/api/2.0/config/subjects.json?roster=#{term}")
		subject_json = JSON.parse(Net::HTTP.get(uri))
		subjects = []
		if subject_json["status"] != "error"
			subject_json["data"]["subjects"].each do |s| 
				if s["value"].include?(query) # could do include? for more comprehensive search results 
					subjects.push({ subject: { value: s["value"], descr: s["descr"] } })
				end 
			end 
		end 
		subjects
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


	def query_courses(term, subjects, q_num)
		courses = []
		subjects.each do |s| 
			subject_uri = URI("https://classes.cornell.edu/api/2.0/search/classes.json?roster=#{term}&subject=#{s}")
			course_json = JSON.parse(Net::HTTP.get(subject_uri))
			if course_json["status"] != "error"
				courses_info = course_json["data"]["classes"]
				courses_info.each do |ci|
					if num_compare(q_num, ci)
						result_json = format_course_less(ci)
						courses.push(result_json)
					end
				end 
			end 
		end 
		courses
	end 




	# Check a full list of queried courses for the course we're looking for 
	def find_course_index(cl_json, num)
		classes = cl_json["data"]["classes"]
		(0...classes.length).each do |i| 
			if classes[i]["catalogNbr"].to_i == num.to_i
				return i
			end
		end 
		return -1 
	end 



end
