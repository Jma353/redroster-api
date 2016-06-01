# == Schema Information
#
# Table name: course_reviews
#
#  id                 :integer          not null, primary key
#  master_course_id   :integer
#  user_id            :integer
#  term               :string
#  lecture_score      :integer
#  office_hours_score :integer
#  difficulty_score   :integer
#  material_score     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  feedback           :string
#

require 'rails_helper'
RSpec.describe Api::V1::CourseReviewsController, type: :controller do

	before(:each) do 
		@user = FactoryGirl.create(:user, google_id: "hello_world")
		@master_course = FactoryGirl.create(:master_course, subject: "CS", number: 1110)
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






	# OBTAINING FULL COURSE REVIEW STATS 

	def create_course_review(user, term, subject, number, scores={}, feedback)
		post :create, { api_key: ENV["API_KEY"], id_token: user.google_id,
					course_review: { 
										term: term, 
										subject: subject, 
										number: number, 
										lecture_score: scores[:lecture],
										office_hours_score: scores[:office_hours],
										difficulty_score: scores[:difficulty],
										material_score: scores[:material],
										feedback: feedback
									 }
								  }
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
