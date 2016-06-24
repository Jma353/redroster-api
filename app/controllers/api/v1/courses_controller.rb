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


	# Param Groups 

	def_param_group :term do 
		param :term, String, :desc => "Term with courses (e.g. 'FA15')", :required => true
	end 

	def_param_group :subject do
		param :subject, String, :descr => "Subject of courses (e.g. 'ORIE')", :required => true
	end 

	def_param_group :number do 
		param :number, String, :descr => "String-form of the number of a course (e.g. '1110')", :required => true 
	end 



	# List of terms 
	api :GET, "/v1/courses/", "Get a list of terms of available courses"
	formats [ 'JSON' ]
	param_group :auth_params, Api::V1::ApplicationController 
	example "
	{
		'success' : true, 
		'data' : {
			'terms' : ['FA14', 'WI15', 'SP15', 'SU15', 'FA15', 'WI16', 'SP16', 'SU16', 'FA16']
		}
	}
	"

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
	api :GET, "/v1/courses/:term", "Get a list of subjects with available courses in a given term"
	formats [ 'JSON' ]
	param_group :auth_params, Api::V1::ApplicationController
	param_group :term
	example "
	{
		'success' : true, 
		'data' : {
			'subjects' : [
				{ 'value' : 'AAS', 
					'descr' : 'Asian American Studies', 
					'descrformal' : 'Asian American Studies'
				}, 
				... 
			]
		}
	}
	"

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
	api :GET, "/v1/courses/:term/:subject", "Get a list of courses by term and subject"
	formats [ 'JSON' ]
	param_group :auth_params, Api::V1::ApplicationController
	param_group :term
	param_group :subject
	example "
	{
		'success' : true, 
		'data' : {
			'courses' : [
				{
					'crse_id' : 358526,
					'subject' : 'CS',
					'catalog_number' : '1110',
					'title_short' : 'Intro Computing Using Python',
					'title_long' : 'Introduction to Computing Using Python',
					'description' : 'Programming and problem solving using Python. Emphasizes principles of software development, 
							style, and testing. Topics include procedures and functions, iteration, recusion, arrays and vectors, strings, 
							an operational model of procedure and function calls, algorithms, exceptions, object-oriented programming, 
							and GUIs (graphical user interfaces). Weekly labs provide guided practice on the computer, with staff present 
							to help. Assignments use graphics and GUIs to help develop fluency and understanding.',
					'term' : 'FA16',
					'prerequisites' : '',
					'credits_minimum' : 4,
					'credits_maximum' : 4,
					'required_sections' : ['LEC', 'DIS'],
					'begin_date' : '08/23/2016',
					'end_date' : '12/02/2016',
					'grading_basis' : 'OPT',
					'cross_listings' : [{ 'subject': 'CS', 'catalogNbr' : '1110' }],
					'people_in_course' : [ ... ]
				}
				...
			]
		}
	}
	"

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
	api :GET, "/v1/courses/:term/:subject/:number", "Get course infomation given a term, subject, and number"
	formats [ 'JSON' ]
	param_group :auth_params, Api::V1::ApplicationController
	param_group :term
	param_group :subject 
	param_group :number
	example "Same JSON format as courses by subject endpoint"

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
	api :GET, "/v1/search_by_subject/:term/:query", "Search for subjects based on query"
	formats [ 'JSON' ]
	param_group :auth_params, Api::V1::ApplicationController
	param_group :term 
	param :query, String, :descr => "Query for a subject with desired courses", :required => true 
	example " 
	{
		'success' : true, 
		'data' : {
			'subjects' : [
					{ 'subject' : { 'value' : 'CAPS', 'descr' : 'China & Asia Pacific Studies' } },
					{ 'subject' : { 'value' : 'PSYCH', 'descr' : 'Psychology' } }
			]
		}
	}
	"

	def search_subjects 
		term = params[:term]
		query = params[:query]
		query.gsub! " ", ""

		subjects = query_subjects(term, query)

		render json: { success: true, data: { subjects: subjects } }

	end 



	# Searching for courses based on a search query
	api :GET, "/v1/search/:term/:query", "Search for courses based on a query"
	formats [ 'JSON' ]
	param_group :auth_params, Api::V1::ApplicationController
	param_group :term
	param :query, String, :descr => "Query for course"
	example "Same JSON format as courses by subject endpoint"

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







