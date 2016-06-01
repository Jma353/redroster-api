# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  term       :string
#  name       :string
#  is_active  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::SchedulesController, type: :controller do


	# Common credentials  
	def common_creds(extra={})
		{ api_key: ENV["API_KEY"] }.merge(extra)
	end 


	# Establish user 
	before(:each) do
		@u = FactoryGirl.create(:user, google_id: 1)	
	end 	

	# Create schedule 
	def create_schedule(u, term, name, is_active)
		post :create, common_creds({ id_token: u.google_id,
			schedule: { term: term, name: name, is_active: is_active }})
	end 

	def schedules_index(u)
		get :index, common_creds({ id_token: u.google_id })
	end 


	# Check the JSON response of each endpoint 
	def check_json_response(response, success=true, print=true)
		json_res = JSON.parse(response.body)
		if print 
			pp json_res
		end 
		expect(response).to be_success
		expect(json_res["success"]).to eq(success)
		json_res
	end


	# Test 1 
	it "Allows successful schedule creation" do 
		create_schedule(@u, "FA15", "Hello world", true)
		resp_json = check_json_response(response, true, false)
	end 

	# Test 2 
	it "Allows successful schedule creation with changes in is_active" do 
		create_schedule(@u, "FA15", "Hello world", true)
		resp_json = check_json_response(response, true, false)

		create_schedule(@u, "FA15", "Hello World 2", true)
		resp_json = check_json_response(response, true, false)

		schedules_index(@u)
		resp_json = check_json_response(response, true, true)
	end 

	# Test 3 
	it "Disallows for creation of schedules with the same name" do 

		common_name = "hello world"

		create_schedule(@u, "FA15", common_name, true)
		resp_json = check_json_response(response, true, false)

		create_schedule(@u, "FA15", common_name, true)
		resp_json = check_json_response(response, false, true)
		
	end 





end










