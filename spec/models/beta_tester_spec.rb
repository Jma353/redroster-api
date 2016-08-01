# == Schema Information
#
# Table name: beta_testers
#
#  id         :integer          not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe BetaTester, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
