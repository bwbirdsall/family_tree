class CreateMom < ActiveRecord::Migration
  def change
    add_column :people, :mom_id, :integer
    add_column :people, :dad_id, :integer
  end
end
