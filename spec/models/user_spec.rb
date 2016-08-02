# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  google_id   :string
#  email       :string
#  fname       :string
#  lname       :string
#  picture_url :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do 

	it "Try create user with an improper email" do 
		@user = User.create(google_id: "lol", email: "lol@gmail.com", fname: "John", lname: "Doe")
		expect(@user.errors.any?).to eq(true)
		pp @user.errors
	end 


	it "Try create user with apple review email an improper email" do 
		@user = User.create(google_id: "lol", email: "redrostertester@gmail.com", fname: "John", lname: "Doe")
		expect(@user.errors.any?).to eq(false)
	end 

	it "Try create user with Cornell email" do 
		@user = User.create(google_id: "lol", email: "jma353@cornell.edu", fname: "John", lname: "Doe")
		expect(@user.errors.any?).to eq(false)
	end

end

