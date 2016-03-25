class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses, {:id => false } do |t|
      t.string :term
      t.string :subject
      t.integer :number

      t.timestamps null: false
    end
    execute "ALTER TABLE courses ADD PRIMARY KEY(term,subject,number)"
  end
end
