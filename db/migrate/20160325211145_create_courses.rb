class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :term
      t.string :subject
      t.integer :number
      
      t.timestamps null: false
    end
  end
end
