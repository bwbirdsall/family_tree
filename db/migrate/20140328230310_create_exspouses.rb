class CreateExspouses < ActiveRecord::Migration
  def change
    create_table :exspouses do |t|
      t.column :person_id, :integer
      t.column :ex_spouse_id, :integer

      t.timestamps
    end
  end
end
