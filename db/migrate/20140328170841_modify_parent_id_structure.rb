class ModifyParentIdStructure < ActiveRecord::Migration
  def change
    remove_column :parents, :parent_id
    remove_column :parents, :person_id
    add_column :parents, :parent1_id, :integer
    add_column :parents, :parent2_id, :integer
    remove_column :people, :dad_id
  end
end
