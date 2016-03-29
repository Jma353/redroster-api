class AddTimeInfoToSections < ActiveRecord::Migration
  def change
    add_column :sections, :start_time, :integer
    add_column :sections, :end_time, :integer
    add_column :sections, :day_pattern, :integer
  end
end
