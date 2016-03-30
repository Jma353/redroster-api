# == Schema Information 
# 
#  Table Name: course_reviews 
#  
#  id 								:integer 					 	not null, PRIMARY KEY 
#  master_course_id 	:integer 						not null/blank
#  user_id 						:integer 						not null/blank
#  term								:string 						
#  lecture						:integer						1..10
#  office_hours 			:integer 						1..10 
#  difficulty					:integer 						1..10 
#  material						:integer 						1..10 
#  feedback						:text 			
#  created_at  				:datetime				 	 	not null
#  updated_at  				:datetime 				 	not null 

include CourseReviewsHelper
class Api::V1::CourseReviewsController < Api::V1::ApplicationController

	before_action :grab_test_user 
	before_action :get_or_create_master_course, only: [:create, :reviews_by_course, :specific_review]



	def get_or_create_master_course 
		subject = params[:course_review][:subject]
		number = params[:course_review][:number]
		@master_course = (MasterCourse.find_by(subject: subject, number: number) || 
											MasterCourse.create(subject: subject, number: number))
	end 






	def create
		@review = CourseReview.create(master_course_id: @master_course.id, 
																	term: course_review_params[:term],
																	lecture: course_review_params[:lecture],
																	office_hours: course_review_params[:office_hours],
																	difficulty: course_review_params[:difficulty],
																	material: course_review_params[:material],
																	feedback: course_review_params[:feedback], 
																	user_id: course_review_params[:user_id])
		
		data = @review.valid? ? ({ course_review: @review }) : ({ errors: @review.errors.full_messages })
		render json: { success: @review.valid?, data: data }  
	end 




	def reviews_by_course 
		master_course_with_reviews = @master_course.as_json([:include_reviews])	
		render json: { success: true, data: master_course_with_reviews }
	end 



	def specific_review 
		p course_review_params[:course_review_id]
		@review = CourseReview.where(master_course_id: @master_course.id).find_by_id(params[:course_review][:course_review_id])

		if !@review.blank? 
			result = @review.as_json.merge({ instructors: get_prof(@review.term, @review.master_course.subject, @review.master_course.number) })
		else 
			result =  {} 
		end 
		render json: { success: !@review.blank?, data: result }
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
				params.require(:course_review).permit(:master_course_id, 
																							:term, 
																							:lecture,
																							:office_hours, 
																							:difficulty, 
																							:material,
																							:feedback).merge(user_id: @user.id)
			else
				return {}
			end 
		end 

end
