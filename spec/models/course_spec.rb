# == Schema Information
#
# Table name: courses
#
#  course_id        :integer          not null, primary key
#  master_course_id :integer
#  term             :string
#  subject          :string
#  number           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Course, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
