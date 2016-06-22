# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  crse_id         :integer
#  term            :string
#  credits_maximum :integer
#  credits_minimum :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class CourseSerializer < ActiveModel::Serializer 
	attributes :id, :crse_id, :term, :credits_maximum, :credits_minimum, :created_at
end 
