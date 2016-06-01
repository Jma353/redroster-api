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

include CourseReviewsHelper
include MasterCourseHelper 
class Api::V1::CourseReviewsController < Api::V1::AuthsController


	before_action :get_or_create_master_course, only: [:create, :reviews_by_course, :specific_review]



	def get_or_create_master_course 
		subject = course_review_params[:subject]
		number = course_review_params[:number].to_i
		@master_course = MasterCourse.find_or_create_by(subject: subject, number: number)  

		if !@master_course.valid? 
			render json: { success: false, data: { errors: ["This course does not exist or is not being referred to properly"] } } and return 
		end 
	end 



	def create
		cr_params = course_review_params({ master_course_id: @master_course.id })
		cr_params.delete(:subject) # Not needed for cr instantiation 
		cr_params.delete(:number) # Not needed for cr instantiation 
		p cr_params
		@review = @user.course_reviews.create(cr_params)	
		data = @review.valid? ? course_review_json(@review)  : { errors: @review.errors.full_messages }
		render json: { success: @review.valid?, data: data }  
	end 




	def reviews_by_course 
		master_course_with_reviews = master_course_with_reviews_json(@master_course)
		render json: { success: true, data: master_course_with_reviews }
	end 



	def specific_review 
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
			render json: { success: false, data: { errors: ["This review either doesn't exist or does not belong to you"] } } and return false
		else 
			render json: { success: true }
		end
	end 





	private 
		def course_review_params(extras={})
			params[:course_review].present? ? params.require(:course_review).permit(:master_course_id, :term, :lecture_score, :office_hours_score, :difficulty_score, :material_score, :feedback, :subject, :number).merge(extras) : {}  
		end 



end
