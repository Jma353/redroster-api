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

class Api::V1::CoursesController < Api::V1::ApplicationController

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
				course_json = { 
												id: c["crseId"], # 123456, unique
												subject: c["subject"], # CS, ORIE, etc. 
												catalog_number: c["catalogNbr"], # 1110, 4999, etc. 
												title_short: c["titleShort"], # Shorter title 
												title_long: c["titleLong"], # Longer title 
												description: c["description"], # Description of course 
												credits_minimum: c["enrollGroups"][0]["unitsMinimum"], # minimum units of this course 
												credits_maximum: c["enrollGroups"][0]["unitsMaximum"], # maximum units of this course 
												required_sections: c["enrollGroups"][0]["componentsRequired"], # components required (e.g. LEC, DIS, etc.)
												begin_data: c["enrollGroups"][0]["sessionBeginDt"], # begin date 
												end_date: c["enrollGroups"][0]["sessionEndDt"], # end data 
											}
				result_json[:data][:courses].push(course_json)
			end 
			render json: result_json

		else 
			render json: { success: false } 
		end 
	end 











end
