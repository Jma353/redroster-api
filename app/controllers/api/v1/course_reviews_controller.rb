# == Schema Information 
# 
#  Table Name: course_reviews 
#  
#  id 								:integer 					 	not null, PRIMARY KEY 
#  master_course_id 	:integer 						not null/blank
#  user_id 						:integer 						not null/blank				
#  feedback						:text 			
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 


class Api::V1::CourseReviewsController < Api::V1::ApplicationController

	before_action :grab_test_user 

	def create
		@review = CourseReview.create(course_review_params)
		data = @review.valid? ? ({ course_review: @review }) : ({ errors: @review.errors.full_error_messages })
		render json: { success: @review.valid?, data: data }  
	end 


	def destroy
		@review = CourseReview.where(user_id: @user.id).find_by_master_course_id(course_review_params[:master_course_id])
		if @review.blank? 
			render json: { success: false, data: { error: "This review either doesn't exist or does not belong to you"} } and return false
		else 
			render json: { success: true }
		end
	end 


	private 

		def course_review_params 
			if params[:course_review].present? 
				params.require(:course_review).permit(:master_course_id, :feedback).merge(user_id: @user.id)
			else
				return {}
			end 
		end 

end
