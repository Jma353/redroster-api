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
  pending "add some examples to (or delete) #{__FILE__}"
end
