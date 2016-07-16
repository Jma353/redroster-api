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
		@user1 = FactoryGirl.create(:user, google_id: "hello_world")
		@user2 = FactoryGirl.create(:user, google_id: "hello_world2")
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
		create_course_review(@user1, review)
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
		create_course_review(@user1, review)
		create_course_review(@user1, review, false) # should fail 
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
		course_review_id = create_course_review(@user1, review)["data"]["course_review"]["id"]
		delete_course_review(@user1, course_review_id)
		expect(CourseReview.find_by(id: course_review_id)).to eq(nil)
	end 


	it "Test that deleting fails if not authorized" do
		review = { 
			crse_id: 11176, 
			term: "FA16",
			lecture_score: 5, 
			office_hours_score: 5, 
			difficulty_score: 3, 
			material_score: 5
		}
		course_review_id = create_course_review(@user1, review)["data"]["course_review"]["id"]
		delete_course_review(@user2, course_review_id, false) # should fail 
		expect(CourseReview.find_by(id: course_review_id)).to_not eq(nil)
	end 


	it "Test obtaining full set of reviews for a course" do 
		# Create several reviews
		(1..10).each do |i| 
			u = FactoryGirl.create(:user, google_id: "#{i}")
			create_course_review(u, { 
				crse_id: 11176,
				term: "FA16",
				lecture_score: rand(1..5),
				office_hours_score: rand(1..5),
				difficulty_score: rand(1..5),
				material_score: rand(1..5),
				feedback: "This is review number #{i}" })
		end 

		get :reviews_by_course, common_creds({ id_token: @user1.google_id, crse_id: 11176 })

		a = { response: response, print: true, success: true }
		check_response(a)

	end

	it "View specific course review via course_review_id" do 
		# Create several reviews
		(1..10).each do |i| 
			u = FactoryGirl.create(:user, google_id: "#{i}")
			create_course_review(u, { 
				crse_id: 11176,
				term: "FA16",
				lecture_score: rand(1..5),
				office_hours_score: rand(1..5),
				difficulty_score: rand(1..5),
				material_score: rand(1..5),
				feedback: "This is review number #{i}" })
		end 

		get :reviews_by_course, common_creds({ id_token: @user1.google_id, crse_id: 11176 })
		a = { response: response, print: false, success: true }
		course_review_id = check_response(a)["data"]["reviews"][0]["course_review"]["id"]

		get :specific_review, common_creds({ id_token: @user2.google_id, course_review_id: course_review_id })
		a = { response: response, print: true, success: true }
		check_response(a)

	end 



end
















