class CreateNicks < ActiveRecord::Migration[5.2]

  def change
    create_table :nicks do |t|
      t.integer :lineage1_id, null: false
      t.integer :lineage2_id, null: false

      t.timestamps
    end
  end
end
