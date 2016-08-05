# == Schema Information
#
# Table name: sections
#
#  id            :integer          not null, primary key
#  section_num   :integer
#  course_id     :integer
#  section_type  :string
#  start_time    :string
#  end_time      :string
#  day_pattern   :string
#  class_number  :string
#  long_location :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class SectionSerializer < ActiveModel::Serializer
	attributes :section_num, :section_type, :start_time, :end_time, :day_pattern, :created_at, :class_number, :long_location, :enroll_group, :topic_description
end 
