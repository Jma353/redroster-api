require 'rails_helper'

RSpec.describe Api::V1::CourseReviewsController, type: :controller do

	before(:each) do 
		@user = FactoryGirl.create(:user, google_id: "hello_world")
		@master_course = FactoryGirl.create(:master_course, subject: "CS", number: 1000)
	end 

	# CREATING COURSE 

	def create_course(user, master_course)
		post :create, { api_key: ENV["API_KEY"], id_token: user.google_id, 
										course_review: { subject: "CS", number: 1110, feedback: "This course rocks" }}

		expect(response).to be_success
		json = JSON.parse(response.body)
		expect(json["success"]).to be(true)
		expect(json["data"]["course_review"]["feedback"]).to eq("This course rocks")
	end 


	it "Test review creation" do
		create_course(@user, @master_course)
	end 


	# DELETING COURSE 

	def delete_course(user, master_course)
		create_course(user, master_course)

		delete :destroy, { api_key: ENV["API_KEY"], id_token: user.google_id, 
											 course_review: { master_course_id: master_course.id }}
		expect(response).to be_success
	end 


	it "test review deletion" do 
		delete_course(@user, @master_course)
	end 







end
