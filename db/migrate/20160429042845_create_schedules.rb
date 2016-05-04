class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
    	t.references :user, index: true 
    	t.string :term 
    	t.string :name

    	t.timestamps null: false
    end
  end
end
