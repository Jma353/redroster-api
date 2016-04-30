# spec/integration/full_schedule_spec.rb 
# Integration spec written to test full schedule creation + integrated validations

require 'rails_helper'


describe "Full Schedule Creation", :type => :request do 

	# Common credentials
	def common_creds(extra={})
		{ api_key: ENV["API_KEY"] }.merge(extra)
	end 


	# Establish a user 
	before(:each) do	
		@u = FactoryGirl.create(:user, google_id: 1)
	end 


	# Create a schedule for a particular user for a specific term 
	def create_schedule(u, term)
		post "/api/v1/schedules/create", common_creds({ id_token: u.google_id, schedule: { term: term }})
	end 

	def show_schedule(u, schedule_id)
		get "/api/v1/schedules/show/#{schedule_id}", common_creds({ id_token: u.google_id })
	end 

	def add_section_to_schedule(u, s)
		post "/api/v1/schedule_elements/create", common_creds({ id_token: u.google_id, schedule_element: s })
	end 

	def remove_section_from_schedule(u, schedule_id, se_id)
		delete "/api/v1/schedule_elements/delete", common_creds({ id_token: u.google_id, schedule_element: { schedule_id: schedule_id, id: se_id }})
	end 

	def destroy_schedule(u, schedule_id)
		delete "/api/v1/schedules/delete/#{schedule_id}", common_creds({ id_token: u.google_id })
	end 



	def check_json_response(response, print=true)
		expect(response).to be_success
		json_res = JSON.parse(response.body)
		if print 
			pp json_res
		end 
		expect(json_res["success"]).to eq(true)
		json_res
	end


	it "schedule creation + adding valid sections to the schedule" do 

		# Create the schedule 
		create_schedule(@u, "FA15")
		json_res = check_json_response(response)

		# Grab the schedule_id for the `show` endpoint 
		schedule_id = json_res["data"]["schedule"]["id"]

		# Show the schedule 
		show_schedule(@u, schedule_id)
		json_res = check_json_response(response)


		# Add networks course to this schedule 
		networks = { 
			:schedule_id => schedule_id, 
			:term => "FA15", 
			:subject => "CS", 
			:course_num => 2850, 
			:section_num => 12447
		}
		add_section_to_schedule(@u, networks)
		json_res = check_json_response(response, false)


		# Show the schedule once again, but with networks added 
		show_schedule(@u, schedule_id)
		json_res = check_json_response(response)
		

		# Add diff_eq to this schedule 
		diff_eq = { 
			:schedule_id => schedule_id, 
			:term => "FA15",
			:subject => "MATH",
			:course_num => 2930,
			:section_num => 6059
		}
		add_section_to_schedule(@u, diff_eq)
		json_res = check_json_response(response, false)

		# Grab the id for later
		diff_eq_id = json_res["data"]["schedule_element"]["id"]


		# Show the schedule once again, but with networks + diff_eq added AND a schedule_conflict present 
		show_schedule(@u, schedule_id)
		json_res = check_json_response(response)


		# Remove diff_eq
		remove_section_from_schedule(@u, schedule_id, diff_eq_id)
		json_res = check_json_response(response, false) 


		# Show the schedule once again, seeing result after diff_eq removal
		show_schedule(@u, schedule_id)
		json_res = check_json_response(response)



		# Test deleting a schedule + removal of all associated schedule_elements 
		destroy_schedule(@u, schedule_id)
		json_res = check_json_response(response, false)


		# There should be none, now
		se = ScheduleElement.where(schedule_id: schedule_id)
		expect(se.length).to eq(0)


		


	end 	






end 



