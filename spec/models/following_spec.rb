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

require 'rails_helper'

RSpec.describe Following, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
