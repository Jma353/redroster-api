class RemoveTypeFromSection < ActiveRecord::Migration
  def change
    remove_column :sections, :type, :string
  end
end
