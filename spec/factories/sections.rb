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

FactoryGirl.define do
  factory :section do
    section_num 1
  end
end
