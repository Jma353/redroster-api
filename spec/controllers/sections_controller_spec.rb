# == Schema Information
#
# Table name: sections
#
#  section_num  :integer          not null, primary key
#  course_id    :integer
#  section_type :string
#  start_time   :string
#  end_time     :string
#  day_pattern  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::SectionsController, type: :controller do

end
