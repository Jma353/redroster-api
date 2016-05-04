# == Schema Information
#
# Table name: master_courses
#
#  id         :integer          not null, primary key
#  subject    :string
#  number     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MasterCourseSerializer < ActiveModel::Serializer
	has_many :course_reviews 
	attributes :id, :subject, :number, :created_at
end 

