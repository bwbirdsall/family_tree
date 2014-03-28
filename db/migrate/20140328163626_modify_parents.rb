class ModifyParents < ActiveRecord::Migration
  def change
    remove_column :parents, :child_id
    add_column :parents, :person_id, :integer
  end
end
