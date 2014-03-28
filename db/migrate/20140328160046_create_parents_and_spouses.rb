class CreateParentsAndSpouses < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.column :parent_id, :integer
      t.column :child_id, :integer

      t.timestamps
    end

    create_table :spouses do |t|
      t.column :spouse1_id, :integer
      t.column :spouse2_id, :integer

      t.timestamps
    end

    remove_column :people, :mom_id, :integer
    remove_column :people, :spouse_id, :integer
  end
end
