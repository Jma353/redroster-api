# == Schema Information
#
# Table name: schedule_elements
#
#  schedule_id :integer          not null, primary key
#  section_num :integer          not null
#  collision   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ScheduleElementSerializer < ActiveModel::Serializer 
	has_one :schedule 
	has_one :section 
	attributes :collision, :created_at
end 