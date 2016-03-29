require 'rails_helper'

RSpec.describe Api::V1::SchedulesController, type: :controller do

	it "Allows successful schedule creation" do 
		u = FactoryGirl.create(:user, google_id: "hello_world")
		post 'create', { api_key: ENV["API_KEY"], id_token: u.google_id, schedule: { term: "FA16" } }
		expect(response).to be_success
		json = JSON.parse(response.body)
		expect(json["success"]).to be(true)
	end 

	it "Requires term on schedule creation" do 
		u = FactoryGirl.create(:user, google_id: "hello_world")
		post 'create', { api_key: ENV["API_KEY"], id_token: u.google_id, schedule: { } }
		expect(response).to be_success
		json = JSON.parse(response.body)
		expect(json["success"]).to be(false)
	end 

end
