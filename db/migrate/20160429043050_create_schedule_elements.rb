class CreateScheduleElements < ActiveRecord::Migration
  def change
    create_table :schedule_elements do |t|
    	t.integer :schedule_id, references: "schedule", index: true
    	t.integer :section_id, references: "section", index: true 
    	t.boolean :collision 

    	t.timestamps null: false
    end
  end
end
