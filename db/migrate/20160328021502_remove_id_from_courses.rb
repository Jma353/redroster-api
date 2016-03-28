class RemoveIdFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :id, :integer
  end
end
