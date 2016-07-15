# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  crse_id         :integer
#  term            :string
#  credits_maximum :integer
#  credits_minimum :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

include CoursesHelper 
class Api::V1::CoursesController < Api::V1::AuthsController 

	# List of terms 
	def list_of_terms
		uri = URI("https://classes.cornell.edu/api/2.0/config/rosters.json")
		res_json = JSON.parse(Net::HTTP.get(uri))
		if res_json["status"] != "error"
			terms = res_json["data"]["rosters"].map { |t| t["slug"] }
			render json: { success: true, data: { terms: terms } } and return 
		else 
			render json: { success: false } and return 
		end 
	end 


	# List of subjects for a given term 
	def subjects_by_term 
		term = params[:term]
		uri = URI("https://classes.cornell.edu/api/2.0/config/subjects.json?roster=#{term}")
		res_json = JSON.parse(Net::HTTP.get(uri))
		if res_json["status"] != "error"
			render json: { success: true, data: { subjects: res_json["data"]["subjects"] } } and return 
		else 
			render json: { success: false } and return 
		end 
	end 


	# List of courses, given a subject and a term 
	def courses_by_subject 
		term = params[:term]
		subject = params[:subject]
		uri = URI("https://classes.cornell.edu/api/2.0/search/classes.json?roster=#{term}&subject=#{subject}") 
		res_json = JSON.parse(Net::HTTP.get(uri))
		if res_json["status"] != "error"
			result_json = { 
				success: true, 
				data: {
					courses: []
				}
			}
			res_json["data"]["classes"].each do |c| 
				c["term"] = term 
				course_json = format_course(c)
				result_json[:data][:courses].push(course_json)
			end 
			render json: result_json and return 

		else 
			render json: { success: false } and return 
		end 
	end 


	# Specific course information, given a term, subject, and thousand number 
	def course_info 
		term = params[:term]
		subject = params[:subject]
		number = params[:number]
		course_level = (number.to_i / 1000) * 1000 # To truncate the num + get the 1000-level of it 
		uri = URI("https://classes.cornell.edu/api/2.0/search/classes.json?roster=#{term}&subject=#{subject}&classLevels[]=#{course_level}")
		res_json = JSON.parse(Net::HTTP.get(uri))
		if res_json["status"] != "error"
			result_json = { success: true, data: { errors: [""] }}
			# Format the course JSON; index i (properly search through the response)
			i = find_course_index(res_json, number)
			if (i == -1) 
				render json: { success: false, data: { errors: ["Course not found."] }} and return 
			end 

			# Create pointer 
			found_json = res_json["data"]["classes"][i]
			# Append the term info 
			found_json["term"] = term 
			# Format the course JSON 
			course_json = format_course(found_json)
			course_json[:class_sections] = res_json["data"]["classes"][i]["enrollGroups"][0]["classSections"]
			result_json[:data] = course_json

			render json: result_json and return 
		else 
			render json: { success: false } and return 
		end 

	end 


	# Search subjects based on term 
	def search_subjects 
		term = params[:term]
		query = params[:query]
		query.gsub! " ", ""

		subjects = query_subjects(term, query)

		render json: { success: true, data: { subjects: subjects } }

	end 


	# Searching for courses based on a search query
	def search_courses
		term = params[:term]
		query = params[:query]
		query.gsub! " ", ""
		i = query.index(/[0-9]/)

		# Utilize these when finding courses
		q_subj = query[0..(i==nil ? -1 : i-1)]
		q_num = i == nil ? i : Integer(query[i..-1])

		subjects = query_subjects(term, q_subj)
		subjects = subjects.map { |s| s[:subject][:value] } # to only include values 
		courses = query_courses(term, subjects, q_num)
		render json: { success: true, data: { courses: courses } }

	end 
	







end







