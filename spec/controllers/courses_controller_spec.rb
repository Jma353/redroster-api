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

require 'rails_helper'

RSpec.describe Api::V1::CoursesController, type: :controller do

	before(:each) do 
		@user = FactoryGirl.create(:user, google_id: "hello_world")
	end 


	it "fetches list of terms properly" do 
		get :list_of_terms, common_creds({ id_token: @user.google_id }) 
		# To check response 
		a = { response: response, print: true, success: true }
		resp_json = check_response(a)
		# Check JSON items 
		expect(resp_json["data"]["terms"]).to include("FA15")
		expect(resp_json["data"]["terms"]).to_not include("FA17")
	end 



	it "fetches subjects of FA16 term" do 
		get :subjects_by_term, common_creds({ id_token: @user.google_id, term: "FA16" })
		# To check response
		a = { response: response, print: true, success: true }
		resp_json = check_response(a)
		# Check JSON items
		expect(resp_json["data"]["subjects"]).to include(({"value"=>"AEM", 
			"descr"=>"Applied Economics & Management",
			"descrformal"=>"Applied Economics & Management"}))
	end 



	it "fetches courses of a FA16 term under subject CS" do
		get :courses_by_subject, common_creds({ id_token: @user.google_id, term: "FA16", subject: "CS" }) 
		# To check response
		a = { response: response, print: true, success: true }
		resp_json = check_response(a)
		# Check JSON items 
		expect(resp_json["data"]["courses"][0]["crse_id"]).to be(358526)
	end 



	it "searches for subjects" do 
		get :search_subjects, common_creds({ id_token: @user.google_id, term: "FA16", query: "PS" })
		# To check response 
		a = { response: response, print: true, success: true }
		resp_json = check_response(a)
	end 



	it "search for courses" do 
		get :search_courses, common_creds({ id_token: @user.google_id, term: "FA16", query: "CS  2"})
		# To check response 
		a = { response: response, print: true, success: true }
		check_response(a)
	end 
	


end






