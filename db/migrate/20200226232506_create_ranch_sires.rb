class CreateRanchSires < ActiveRecord::Migration[5.2]

  def change
    create_table :ranch_sires do |t|
      t.references :ranch      , null: false, foreign_key: true
      t.references :sire       , null: false, foreign_key: true
      t.integer    :year_leased, null: false

      t.timestamps
    end
  end
end
