# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  google_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module UsersHelper

	def user_json(u)
		UserSerializer.new(u).as_json
	end 



end
