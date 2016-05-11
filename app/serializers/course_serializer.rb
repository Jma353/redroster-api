# == Schema Information
#
# Table name: courses
#
#  course_id        :integer          not null, primary key
#  master_course_id :integer
#  term             :string
#  subject          :string
#  number           :integer
#  credits_maximum  :integer
#  credits_minimum  :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class CourseSerializer < ActiveModel::Serializer 
	# has_one :master_course
	attributes :course_id, :term, :subject, :number, :created_at, :credits_maximum, :credits_minimum
end 
