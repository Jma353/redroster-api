# spec/integration/full_schedule_spec.rb 
# Integration spec written to test full schedule creation + integrated validations

require 'rails_helper'


describe "Full Schedule Creation", :type => :request do 

	# Common credentials
	def common_creds(extra={})
		{ api_key: ENV["API_KEY"] }.merge(extra)
	end 


	# Establish users
	before(:each) do	
		@u = FactoryGirl.create(:user, google_id: 1, fname: "Joe", lname: "Antonakakis")
		@u2 = FactoryGirl.create(:user, google_id: 2, fname:  "Daniel", lname: "Li")
		@u3 = FactoryGirl.create(:user, google_id: 3, fname: "Emily", lname: "Smith")
	end 

	# Create a schedule for a particular user for a specific term 
	def create_schedule(u, term, name, is_active)
		post "/api/v1/schedules/create", common_creds({ id_token: u.google_id, schedule: { term: term, name: name, is_active: is_active }})
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
	
	def check_json_response(response, print=true, success=true)
		expect(response).to be_success
		json_res = JSON.parse(response.body)
		if print 
			pp json_res
		end 
		expect(json_res["success"]).to eq(success)
		json_res
	end


	it "schedule creation + adding valid sections to the schedule" do 

		# Create the schedule 
		create_schedule(@u, "FA15", "my sched", true)
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
			:section_num => [12447]
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
			:section_num => [6059]
		}
		add_section_to_schedule(@u, diff_eq)
		json_res = check_json_response(response, true)

		# Grab the id for later
		diff_eq_id = json_res["data"]["schedule"]["courses"][1]["schedule_elements"][0]["schedule_element"]["id"]
		p diff_eq_id

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




	it  "Schedule creation + calling course endpoints to see users in them" do 

		# The courses we're returning information for 
		# Networks 
		networks = { 
			:term => "FA15", 
			:subject => "CS", 
			:course_num => 2850, 
			:section_num => [12447]
		}

		# Python 
		python_class = {
			:term => "FA15",
			:subject => "CS",
			:course_num => 1110,
			:section_num => [11829]
		}



		# Create u schedule + sched_id
		create_schedule(@u, "FA15", "u sched", true)
		res_json = check_json_response(response, false)
		u_sched_id = res_json["data"]["schedule"]["id"]
		# Create u2 schedule + sched_id
		create_schedule(@u2, "FA15", "u2 sched", true)
		res_json = check_json_response(response, false)
		u2_sched_id = res_json["data"]["schedule"]["id"]
		# Create u3 schedule + sched_id
		create_schedule(@u3, "FA15", "u3 sched", true)
		res_json = check_json_response(response, false)
		u3_sched_id = res_json["data"]["schedule"]["id"]



		# Add networks and python to u schedule 
		add_section_to_schedule(@u, networks.clone.merge({ schedule_id: u_sched_id }))
		add_section_to_schedule(@u, python_class.clone.merge({ schedule_id: u_sched_id }))

		# Now that u has added these to their schedule, we should see them on requesting
		# both courses from the course endpoints 
		get "/api/v1/courses/FA15/CS/2850", common_creds
		res_json = check_json_response(response, false)
		pp "People in Networks"
		pp res_json["data"]["people_in_course"] # Should just be the one person 

		get "/api/v1/courses/FA15/CS/1110", common_creds
		res_json = check_json_response(response, false)
		pp "People in Python"
		pp res_json["data"]["people_in_course"]



		# Add networks and python to u2 schedule 
		add_section_to_schedule(@u2, networks.clone.merge({ schedule_id: u2_sched_id }))
		add_section_to_schedule(@u2, python_class.merge({ schedule_id: u2_sched_id }))



		# Now that u + u2 has added these to their schedule, we should see them on requesting
		# both courses from the course endpoints 
		get "/api/v1/courses/FA15/CS/2850", common_creds
		res_json = check_json_response(response, false)
		pp "People in Networks"
		pp res_json["data"]["people_in_course"] # Should just be the one person 

		get "/api/v1/courses/FA15/CS/1110", common_creds
		res_json = check_json_response(response, false)
		pp "People in Python"
		pp res_json["data"]["people_in_course"]



		# Now, u2 destroys his schedule :(
		destroy_schedule(@u2, u2_sched_id)


		# Only u should come up 
		get "/api/v1/courses/FA15/CS/2850", common_creds
		res_json = check_json_response(response, false)
		pp "People in Networks"
		pp res_json["data"]["people_in_course"] # Should just be the one person 

		get "/api/v1/courses/FA15/CS/1110", common_creds
		res_json = check_json_response(response, false)
		pp "People in Python"
		pp res_json["data"]["people_in_course"]




	end 

	










end 



