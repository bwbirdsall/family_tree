class DropSpousesTableGetSpouseIdBack < ActiveRecord::Migration
  def change
    drop_table :spouses
    add_column :people, :spouse_id, :integer
  end
end
