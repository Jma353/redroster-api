# == Schema Information
#
# Table name: beta_testers
#
#  id         :integer          not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BetaTesterSerializer < ActiveModel::Serializer
  attributes :email
end
