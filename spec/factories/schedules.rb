# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  term       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :schedule do
    user_id 1
    term "FA15"
  end
end
