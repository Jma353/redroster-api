# == Schema Information
#
# Table name: master_courses
#
#  id         :integer          not null, primary key
#  subject    :string
#  number     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe MasterCourse, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
