# == Schema Information
#
# Table name: following_requests
#
#  id          :integer          not null, primary key
#  user1_id    :integer
#  user2_id    :integer
#  sent_by_id  :integer
#  is_pending  :boolean
#  is_accepted :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::FollowingRequestsController, type: :controller do

	# Common credentials 
	def common_creds(extra={})
		{ api_key: ENV["API_KEY"]}.merge(extra)
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


	# Before each test 
	before(:each) do 
		@u1 = FactoryGirl.create(:user, google_id: 123)
		@u2 = FactoryGirl.create(:user, google_id: 124)
	end 



	# Sending following request from user1 to user2 
	it "Create successful following request" do

		post :create, 
		common_creds({ id_token: @u1.google_id, 
			following_request: { user1_id: @u1.id, user2_id: @u2.id }})

		json_res = check_json_response(response)
	end 



	# Send following request from user1 to user2 and fail
	it "Try to friend myself" do 
		post :create,
		common_creds({ id_token: @u1.google_id, 
			following_request: { user1_id: @u1.id, user2_id: @u1.id }})

		json_res = check_json_response(response, false)
	end 






end












