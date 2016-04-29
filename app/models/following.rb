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

class Following < ActiveRecord::Base
	# References 
	belongs_to :user1, class_name: "User", foreign_key: "user1_id"
	belongs_to :user2, class_name: "User", foreign_key: "user2_id"


	


end
