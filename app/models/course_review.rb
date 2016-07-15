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

class CourseReview < ActiveRecord::Base
	# References 
	belongs_to :user, class_name: "User", foreign_key: "user_id"

	validates :user_id, presence: true
	validates :lecture_score, allow_blank: false, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
	validates :office_hours_score, allow_blank: false, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
	validates :difficulty_score, allow_blank: false, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
	validates :material_score, allow_blank: false, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
	validates	:feedback, allow_blank: true, length: { maximum: 200 } # => max 200 character feedback 

	validate :user_has_not_reviewed, :on => :create 

	def user_has_not_reviewed 
		c = CourseReview.where(crse_id: self.crse_id).find_by_user_id(self.user_id)
		errors[:base] << ("You have already reviewed this course") unless c.blank? 
	end 
	


end
