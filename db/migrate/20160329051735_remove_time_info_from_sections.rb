class RemoveTimeInfoFromSections < ActiveRecord::Migration
  def change
    remove_column :sections, :start_time, :integer
    remove_column :sections, :end_time, :integer
    remove_column :sections, :day_pattern, :integer
  end
end
