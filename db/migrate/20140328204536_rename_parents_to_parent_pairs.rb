class RenameParentsToParentPairs < ActiveRecord::Migration
  def change
    rename_table(:parents, :parent_pairs)
  end
end
