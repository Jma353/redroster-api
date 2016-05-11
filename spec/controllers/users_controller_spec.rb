# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  google_id   :string
#  email       :string
#  fname       :string
#  lname       :string
#  picture_url :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do


	# Common credentials 
	def common_creds(extra={})
		{ api_key: ENV["API_KEY"]}.merge(extra)
	end 

	# Creating a user method 
	def create_user(google_id=1)
		post_json = common_creds({ user: { google_id: google_id }})
		post :create, post_json
	end 


	it "tests user creation" do 
		create_user(2)
		expect(response).to be_success
		res_json = JSON.parse(response.body)
		pp res_json
		expect(res_json["success"]).to eq(true)
		expect(res_json["data"]["user"]["google_id"]).to eq(2)
	end 




end







