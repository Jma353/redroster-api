# == Schema Information
#
# Table name: schedule_elements
#
#  schedule_id :integer          not null, primary key
#  section_num :integer          not null
#  collision   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::ScheduleElementsController, type: :controller do

end
