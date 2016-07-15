# == Schema Information
#
# Table name: course_reviews
#
#  id                 :integer          not null, primary key
#  crse_id            :integer
#  user_id            :integer
#  term               :string
#  lecture_score      :integer
#  office_hours_score :integer
#  difficulty_score   :integer
#  material_score     :integer
#  feedback           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::CourseReviewsController, type: :controller do

	before(:each) do 
		@user = FactoryGirl.create(:user, google_id: "hello_world")
		@course = FactoryGirl.create(:course, crse_id: 11176, term: "FA16", credits_minimum: 4, credits_maximum: 4)
	end 

	def create_course_review(user, review, success=true)
		post :create, common_creds({ id_token: user.google_id, course_review: review }) 
		a = { response: response, print: true, success: success }
		check_response(a)
	end 

	def delete_course_review(user, id, success=true)
		delete :destroy, common_creds({ id_token: user.google_id, course_review_id: id })
		a = { response: response, print: true, success: success }
		check_response(a)
	end


	it "Test review creation for CS 1110 in FA16" do
		review = { 
			crse_id: 11176, 
			term: "FA16",
			lecture_score: 5, 
			office_hours_score: 5, 
			difficulty_score: 3, 
			material_score: 5,
			feedback: "This course is unreal"
		}
		create_course_review(@user, review)
	end 


	it "Test inability to review a course a second time" do 
		review = { 
			crse_id: 11176, 
			term: "FA16",
			lecture_score: 5, 
			office_hours_score: 5, 
			difficulty_score: 3, 
			material_score: 5
		}
		create_course_review(@user, review)
		create_course_review(@user, review, false) # should fail 
	end 


	it "Test deleting a course review" do 
		review = { 
			crse_id: 11176, 
			term: "FA16",
			lecture_score: 5, 
			office_hours_score: 5, 
			difficulty_score: 3, 
			material_score: 5
		}
		course_review_id = create_course_review(@user, review)["data"]["course_review"]["id"]
		delete_course_review(@user, course_review_id)
		expect(CourseReview.find_by(id: course_review_id)).to eq(nil)
	end 


	it "test obtaining full set of reviews for a course" do 
		# Create several reviews
		(1..10).each do |i| 
			u = FactoryGirl.create(:user, google_id: "#{i}")
			create_course_review(u, "FA15","CS", 1110, { lecture: rand(1..10),
										office_hours: rand(1..10),
										difficulty: rand(1..10),
										material: rand(1..10)
										}, "This is review number #{i}")
		end 



		get :reviews_by_course, { api_key: ENV["API_KEY"], id_token: @user.google_id, 
			course_review: { subject: "CS", number: 1110 }
		}

		expect(response).to be_success
		json = JSON.parse(response.body)
		expect(json["success"]).to be(true)
		random_review_id = json["data"]["master_course"]["course_reviews"][0]["id"]
		pp random_review_id



		get :specific_review, { api_key: ENV["API_KEY"], id_token: @user.google_id,
					course_review: { subject: "CS", number: 1110, course_review_id: random_review_id } }

		expect(response).to be_success 
		json = JSON.parse(response.body)
		p json

	end



end
