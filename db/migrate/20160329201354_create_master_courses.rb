class CreateMasterCourses < ActiveRecord::Migration
  def change
    create_table :master_courses do |t|
      t.string :subject
      t.integer :number

      t.timestamps null: false
    end
  end
end
