# == Schema Information
#
# Table name: schedule_elements
#
#  id          :integer          not null, primary key
#  schedule_id :integer
#  section_id  :integer
#  collision   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module ScheduleElementsHelper

  def update_se_collisions(schedule)
    schedule.schedule_elements.each do |se|
      se.update_attributes(collision: se.collisions?)
    end
  end

  def schedule_element_json(se)
    ScheduleElementSerializer.new(se).as_json
  end

end
