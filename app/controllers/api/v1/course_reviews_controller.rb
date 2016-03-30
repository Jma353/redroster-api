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
	before_action :get_or_create_master_course, only: [:create, :reviews_by_course]



	def get_or_create_master_course 
		subject = params[:course_review][:subject]
		number = params[:course_review][:number]
		@master_course = (MasterCourse.find_by(subject: subject, number: number) || 
											MasterCourse.create(subject: subject, number: number))
	end 



	def create
		@review = CourseReview.create(master_course_id: @master_course.id, 
																	feedback: course_review_params[:feedback], 
																	user_id: course_review_params[:user_id])

		data = @review.valid? ? ({ course_review: @review }) : ({ errors: @review.errors.full_messages })
		render json: { success: @review.valid?, data: data }  
	end 



	def show 
		# TODO 
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
