require 'rails_helper'

RSpec.describe Api::V1::CoursesController, type: :controller do

	before(:each) do 
		@user = FactoryGirl.create(:user, google_id: "hello_world")
	end 

	it "fetches list of terms properly" do 
		get :list_of_terms, { api_key: ENV["API_KEY"], id_token: @user.google_id }
		expect(response).to be_success 
		json = JSON.parse(response.body)
		expect(json["success"]).to be(true)
		expect(json["data"]["terms"]).to include("FA15")
		expect(json["data"]["terms"]).to_not include("FA17")
	end 


	it "fetches subjects of FA16 term" do 
		get :subjects_by_term, { api_key: ENV["API_KEY"], id_token: @user.google_id, term: "FA16" }
		expect(response).to be_success
		json = JSON.parse(response.body)
		expect(json["success"]).to be(true)
		expect(json["data"]["subjects"]).to include(({"value"=>"AEM", 
																									"descr"=>"Applied Economics & Management",
																									"descrformal"=>"Applied Economics & Management"}))
	end 


	it "fetches courses of a FA16 term under subject CS" do
		get :courses_by_subject, { api_key: ENV["API_KEY"], id_token: @user.google_id, term: "FA16", subject: "CS" }
		expect(response).to be_success 
		json = JSON.parse(response.body)
		expect(json["success"]).to be(true)
		expect(json["data"]["courses"][0]["id"]).to be(358526)
	end 

	



end


