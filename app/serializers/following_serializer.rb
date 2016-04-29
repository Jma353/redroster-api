# == Schema Information
#
# Table name: followings
#
#  id              :integer          not null, primary key
#  user1_id        :integer
#  user2_id        :integer
#  is_active       :boolean
#  following_score :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class FollowingSerializer < ActiveModel::Serializer 
	has_one :user1
	has_one :user2 
	attributes :id, :is_active, :following_score
end
