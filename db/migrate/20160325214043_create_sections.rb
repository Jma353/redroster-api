class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections, { :id => false } do |t|
      t.integer :section_num

      t.timestamps null: false
    end
    execute "ALTER TABLE sections ADD PRIMARY KEY (section_num);"
  end
end
