# spec/integration/followings_integration_spec.rb 
# Integration spec written to test following requests + obtaining lists of followers 

require 'rails_helper'

describe "Followings Integration Tests", :type => :request do 

	# Establish users 
	before(:each) do 
		@u1 = FactoryGirl.create(:user, google_id: 1, fname: "Joe", lname: "Antonakakis") 
		@u2 = FactoryGirl.create(:user, google_id: 2, fname: "Daniel", lname: "Li")
		@u3 = FactoryGirl.create(:user, google_id: 3, fname: "Bob", lname: "Smith")
	end 


	# Check the JSON response of each endpoint 
	def check_json_response(response, success=true, print=true)
		expect(response).to be_success
		json_res = JSON.parse(response.body)
		if print 
			pp json_res
		end 
		expect(json_res["success"]).to eq(success)
		json_res
	end


	# Create a following_request 
	def create_following_request(s, r)
		post "/api/v1/following_requests/create/", 
		common_creds({ id_token: s.google_id, 
			following_request: { user_id: r.id }})
	end 

	# React to following_request 
	def react_to_following_request(u, accept, fr_id)
		post "/api/v1/following_requests/react_to_request/#{accept}", 
		common_creds({ id_token: u.google_id, 
			following_request: { id: fr_id }}) 
	end 

	# Fetch followers 
	def fetch_followers(u)
		get '/api/v1/followings/fetch_followers',
		common_creds({ id_token: u.google_id })
	end 

	# Fetch followees 
	def fetch_followees(u)
		get '/api/v1/followings/fetch_followees',
		common_creds({ id_token: u.google_id })
	end 

	# Fetch followings 
	def fetch_followings(u)
		get '/api/v1/followings/fetch_followings',
		common_creds({ id_token: u.google_id })
	end 


	# u1 follows u2 and u3, followed by u2
	# u1 checking followers, followees, followings 
	it "Following requests + acceptances + listings" do 

		# u1 follows u2 
		create_following_request(@u1, @u2)
		json_res = check_json_response(response, true, false)
		fr_id = json_res["data"]["following_request"]["id"]
		react_to_following_request(@u2, true, fr_id)
		json_res = check_json_response(response, true, false)

		# Check followee of u1 
		fetch_followees(@u1)
		json_res = check_json_response(response)
		expect(json_res["data"]["followees"].size).to eq(1)

		# u1 follows u3 
		create_following_request(@u1, @u3)
		json_res = check_json_response(response, true, false)
		fr_id = json_res["data"]["following_request"]["id"]
		react_to_following_request(@u3, true, fr_id)
		json_res = check_json_response(response, true, false)

		# Check followees of u1 
		fetch_followees(@u1)
		json_res = check_json_response(response)
		expect(json_res["data"]["followees"].size).to eq(2)

		# u2 follows u1 
		create_following_request(@u2, @u1)
		json_res = check_json_response(response, true, false)
		fr_id = json_res["data"]["following_request"]["id"]
		react_to_following_request(@u1, true, fr_id)
		json_res = check_json_response(response, true, false)

		# Check the followees of u2 
		fetch_followees(@u2)
		json_res = check_json_response(response)
		expect(json_res["data"]["followees"].size).to eq(1)

		# Check the followers of u3
		fetch_followers(@u3)
		json_res = check_json_response(response)
		expect(json_res["data"]["followers"].size).to eq(1)


		# Check the followings of u1 
		fetch_followings(@u1)
		json_res = check_json_response(response)
		expect(json_res["data"]["followings"].size).to eq(2)


	end 


	





end 













