# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  term       :string
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


	it "Allows successful schedule creation" do 
		post :create, common_creds({ id_token: @u.google_id, schedule: { term: "FA15" }})
		expect(response).to be_success
		json = JSON.parse(response.body)
		expect(json["success"]).to be(true)
		pp json 
	end 




end
