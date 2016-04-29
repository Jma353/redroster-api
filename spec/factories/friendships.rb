# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user1_id   :integer
#  user2_id   :integer
#  is_active  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :friendship do
    user1_id 1
    user2_id 1
    is_active false
  end
end
