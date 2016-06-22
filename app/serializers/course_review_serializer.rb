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

class CourseReviewSerializer < ActiveModel::Serializer
	# has_one :master_course
	has_one :user
	attributes :id, :term, :lecture_score, :office_hours_score, :difficulty_score, :material_score, :feedback, :created_at
end 
