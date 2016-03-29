class AddCorrectTimeInfoToSections < ActiveRecord::Migration
  def change
    add_column :sections, :start_time, :string
    add_column :sections, :end_time, :string
    add_column :sections, :day_pattern, :string
  end
end
