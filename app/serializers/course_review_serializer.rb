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

class CourseReviewSerializer < ActiveModel::Serializer
	has_one :master_course
	has_one :user
	attributes :id, :term, :lecture_score, :office_hours_score, :difficulty_score, :material_score, :created_at
end 