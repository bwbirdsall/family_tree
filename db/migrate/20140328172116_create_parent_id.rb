class CreateParentId < ActiveRecord::Migration
  def change
    add_column :people, :parent_id, :integer
  end
end
