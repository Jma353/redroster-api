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


include CoursesHelper 
class Api::V1::CoursesController < Api::V1::ApplicationController

	##### GET ENDPOINTS BASED ON THE CORNELL COURSE API ##### 

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
				course_json = format_course(c)
				result_json[:data][:courses].push(course_json)
			end 
			render json: result_json and return 

		else 
			render json: { success: false } and return 
		end 
	end 


	# Specific course information, given a subject, a course, and a course_id # 
	def course_info 
		term = params[:term]
		subject = params[:subject]
		number = params[:number]
		course_level = (number.to_i / 1000) * 1000 # To truncate the num + get the 1000-level of it 
		p course_level
		uri = URI("https://classes.cornell.edu/api/2.0/search/classes.json?roster=#{term}&subject=#{subject}&classLevels[]=#{course_level}")
		res_json = JSON.parse(Net::HTTP.get(uri))
		p res_json
		if res_json["status"] != "error"
			result_json = { 
											success: true, 
											# Data is to go here 
										}
			# Format the course JSON; index i (properly search through the response)
			i = find_course_index(res_json, number)
			if (i == -1) 
				render json: { success: false, data: { errors: ["Course not found."]}} and return 
			end 
			course_json = format_course(res_json["data"]["classes"][i])
			course_json[:class_sections] = res_json["data"]["classes"][0]["enrollGroups"][0]["classSections"]
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







