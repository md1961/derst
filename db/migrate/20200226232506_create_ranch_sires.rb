class CreateRanchSires < ActiveRecord::Migration[5.2]

  def change
    create_table :ranch_sires do |t|
      t.references :ranch, null: false, foreign_key: true
      t.references :sire , null: false, foreign_key: true

      t.timestamps
    end
  end
end
