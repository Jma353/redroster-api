# == Schema Information
#
# Table name: courses
#
#  id                  :integer          not null, primary key
#  crse_id             :integer
#  term                :string
#  subject             :string
#  catalog_number      :integer
#  course_offer_number :integer
#  credits_maximum     :integer
#  credits_minimum     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Course, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
