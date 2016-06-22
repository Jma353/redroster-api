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

include CourseReviewsHelper
class Api::V1::CourseReviewsController < Api::V1::AuthsController

	
	def create
		@review = @user.course_reviews.create(course_review_params)
		data = @review.valid? ? course_review_json(@review)  : { errors: [@review.errors.full_messages] }
		render json: { success: @review.valid?, data: data }  
	end 


	def reviews_by_course 
		@crse_id = course_review_params[:crse_id]
		@course_reviews = CourseReviews.find_by_crse_id(crse_id)
		render json: { success: true, data: reviews_by_course_json(@crse_id, @course_reviews) }
	end 


	def specific_review 
		@review = CourseReview.find_by_id(params[:course_review_id])
		result = !@review.blank? ? course_review_json(@review) : {} 
		render json: { success: !@review.blank?, data: result }
	end 


	def destroy
		@review = CourseReview.where(user_id: @user.id).find_by_id(params[:course_review_id])
		if @review.blank? 
			render json: { success: false, data: { errors: ["This review either doesn't exist or does not belong to you"] } } and return false
		else 
			render json: { success: true }
		end
	end 


	private 
		def course_review_params(extras={})
			params[:course_review].present? ? params.require(:course_review).permit(:term, :lecture_score, :office_hours_score, :difficulty_score, :material_score, :feedback, :crse_id).merge(extras) : {}  
		end 



end



