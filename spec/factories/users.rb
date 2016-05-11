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
    picture_url "https://upload.wikimedia.org/wikipedia/en/0/05/Master_Chief_in_Halo_5.png"
  end
end
