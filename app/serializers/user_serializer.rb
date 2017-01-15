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

class UserSerializer < ActiveModel::Serializer
  attributes :id, :fname, :lname, :email, :picture_url
end
