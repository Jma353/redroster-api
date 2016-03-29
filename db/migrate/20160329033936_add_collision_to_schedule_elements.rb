class AddCollisionToScheduleElements < ActiveRecord::Migration
  def change
    add_column :schedule_elements, :collision, :boolean
  end
end
