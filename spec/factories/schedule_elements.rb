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

FactoryGirl.define do
  factory :schedule_element do
    schedule_id 1
    section_id 1
  end
end
