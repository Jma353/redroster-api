# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  google_id  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserSerializer < ActiveModel::Serializer
	attributes :google_id


end 
