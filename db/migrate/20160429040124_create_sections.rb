class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :section_num
      t.integer :course_id, references: "course", index: true
      t.string :section_type
      t.string :start_time
      t.string :end_time
      t.string :day_pattern
        t.string :class_number
        t.string :long_location

      t.timestamps null: false

    end
  end
end
