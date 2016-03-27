# == Schema Information 
# 
#  Table Name: courses 
#  
#  id					 				:integer					 	not null, PRIMARY KEY 
#  term 							:string 					 	not null/blank, 4 characters 
#  subject 		 				:string 				   	not null/blank, 2 or more characters 
#  number			 				:integer 				   	not null/blank, 1000..9999 range 
#  created_at  				:datetime				   	not null
#  updated_at  				:datetime 				 	not null 

include CoursesHelper 
class Api::V1::CoursesController < Api::V1::ApplicationController


	# List of terms 
	def list_of_terms
		uri = URI("https://classes.cornell.edu/api/2.0/config/rosters.json")
		res_json = JSON.parse(Net::HTTP.get(uri))
		if res_json["status"] != "error"
			terms = res_json["data"]["rosters"].map { |t| t["slug"] }
			render json: { success: true, data: { terms: terms } } 
		else 
			render json: { success: false }
		end 
	end 




	# List of subjects for a given term 
	def subjects_by_term 
		term = params[:term]
		uri = URI("https://classes.cornell.edu/api/2.0/config/subjects.json?roster=#{term}")
		res_json = JSON.parse(Net::HTTP.get(uri))
		if res_json["status"] != "error"
			render json: { success: true, data: { subjects: res_json["data"]["subjects"] }  }
		else 
			render json: { success: false }
		end 
	end 



	# List of courses, given a subject and a term 
	def courses_by_subject 
		term = params[:term]
		subject = params[:subject]
		uri = URI("https://classes.cornell.edu/api/2.0/search/classes.json?roster=#{term}&subject=#{subject}") 
		res_json = JSON.parse(Net::HTTP.get(uri))
		if res_json["status"] != "error"
			result_json = { success: true, 
											data: {
												courses: []
											}
										}
			res_json["data"]["classes"].each do |c| 
				course_json = format_course(c)
				result_json[:data][:courses].push(course_json)
			end 
			render json: result_json

		else 
			render json: { success: false } 
		end 
	end 






	# Specific course information, given a subject, a course, and a course_id # 

	def course_info 
		term = params[:term]
		subject = params[:subject]
		number = params[:number]
		uri = URI("https://classes.cornell.edu/api/2.0/search/classes.json?roster=#{term}&subject=#{subject}&q=#{number}")
		res_json = JSON.parse(Net::HTTP.get(uri))
		if res_json["status"] != "error"
			render json: { success: true }
		else 
			render json: { success: false }
		end 


	end 













end
