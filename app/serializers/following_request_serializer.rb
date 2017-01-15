# == Schema Information
#
# Table name: following_requests
#
#  id          :integer          not null, primary key
#  user1_id    :integer
#  user2_id    :integer
#  sent_by_id  :integer
#  is_pending  :boolean
#  is_accepted :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FollowingRequestSerializer < ActiveModel::Serializer
  has_one :user1
  has_one :user2
  attributes :id, :is_pending, :is_accepted, :created_at
end
