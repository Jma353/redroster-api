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
#

require 'rails_helper'

RSpec.describe CourseReview, type: :model do
 		
		
	before(:each) do 
		@u = FactoryGirl.create(:user, google_id: 12)
		@mc = FactoryGirl.create(:master_course, subject: "CS", number: 1110)
	end 



 	it "test course review creation" do 
 		review = CourseReview.create(user_id: @u.id, master_course_id: @mc.id, term: "FA14", 
 		lecture_score: 10, office_hours_score: 10, difficulty_score: 10, material_score: 10)
 		
 		if review.errors.any?
 			review.errors.full_messages.each do |m|
 				p m
 			end 
 		end 
 		r_json = CourseReviewSerializer.new(review).as_json
 		pp r_json
 	end 


end
