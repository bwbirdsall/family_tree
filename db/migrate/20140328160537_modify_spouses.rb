class ModifySpouses < ActiveRecord::Migration
  def change
    remove_column :spouses, :spouse1_id
    remove_column :spouses, :spouse2_id
    add_column :spouses, :person_id, :integer
    add_column :spouses, :spouse_id, :integer
  end
end
