# == Schema Information
#
# Table name: courses
#
#  course_id        :integer          not null, primary key
#  master_course_id :integer
#  term             :string
#  subject          :string
#  number           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :course do
    term "MyString"
    subject "MyString"
    number 1
  end
end
