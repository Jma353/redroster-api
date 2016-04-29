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

class CourseReview < ActiveRecord::Base
	# References 
	belongs_to :master_course, class_name: "MasterCourse", foreign_key: "master_course_id"
	belongs_to :user, class_name: "User", foreign_key: "user_id"


	validates :master_course_id, presence: true 
	validates :user_id, presence: true
	validates :lecture_score, allow_blank: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
	validates :office_hours_score, allow_blank: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
	validates :difficulty_score, allow_blank: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
	validates :material_score, allow_blank: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
	# validates	:feedback, allow_blank: true, length: { maximum: 200 } # => max 200 character feedback 

	validate :user_has_not_reviewed, :on => :create 

	def user_has_not_reviewed 
		c = CourseReview.where(master_course_id: self.master_course_id).find_by_user_id(self.user_id)
		errors[:base] << ("You have already reviewed this course") unless c.blank? 
	end 
	

	# Will change later to feat. usernames or handles or something 
	def as_json(options={})
		super({ only: [:id, :user_id, :term, :lecture, :office_hours, :difficulty, :material, :feedback] }.merge(options))
	end 


end
