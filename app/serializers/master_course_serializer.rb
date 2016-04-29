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
	attributes :id, :subject, :number, :created_at
end 

