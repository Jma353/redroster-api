class CreateScheduleElements < ActiveRecord::Migration
  def change
    create_table :schedule_elements, { :id => false } do |t|
    	t.integer :schedule_id, references: "schedule", index: true
    	t.integer :section_num, references: "section", index: true 
    	t.boolean :collision 

    	t.timestamps null: false
    end
    execute "ALTER TABLE schedule_elements ADD PRIMARY KEY(schedule_id,section_num);"
  end
end
