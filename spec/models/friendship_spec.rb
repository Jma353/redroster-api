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

require 'rails_helper'

RSpec.describe Friendship, type: :model do


	before(:each) do 
		@f1 = FactoryGirl.create(:user, google_id: 1)
		@f2 = FactoryGirl.create(:user, google_id: 2)
	end 
 

	it "test friendship creation" do 
		f = Friendship.create(user1_id: @f1.id, user2_id: @f2.id, is_active: false)
		expect(f.user1_id).to eq(@f1.id)
		f_json = FriendshipSerializer.new(f).as_json 
		expect(f_json["friendship"][:user1][:google_id]).to eq(@f1.google_id)
		expect(f_json["friendship"][:user2][:google_id]).to eq(@f2.google_id)

	end 


end
