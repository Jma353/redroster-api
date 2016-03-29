class AddTermToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :term, :string
  end
end
