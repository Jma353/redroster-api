class CreateScheduleElements < ActiveRecord::Migration
  def change
    create_table :schedule_elements, { :id => false } do |t|
      t.integer :schedule_id
      t.integer :section_id

      t.timestamps null: false
    end

    execute "ALTER TABLE schedule_elements ADD PRIMARY KEY(schedule_id,section_id);"
    
  end
end
