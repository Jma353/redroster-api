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

FactoryGirl.define do
  factory :user do
    google_id "MyString"
    fname "First_Name"
    lname "Last_Name"
    email "email@cornell.edu"
    picture_url "https://goo.gl/npBHNI"
  end
end
