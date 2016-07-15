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

FactoryGirl.define do
  factory :course do
    term "FA16"
    crse_id 11176
    credits_minimum 4
    credits_maximum 4
  end
end
