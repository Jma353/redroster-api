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

FactoryGirl.define do
  factory :master_course do
    subject "MyString"
    number 1
  end
end
