# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  google_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserSerializer < ActiveModel::Serializer
	attributes :google_id
end 
