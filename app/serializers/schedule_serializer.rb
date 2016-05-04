# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  term       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ScheduleSerializer < ActiveModel::Serializer
	# has_one :user
	# has_many :schedule_elements 
	attributes :id, :term, :created_at
end 

