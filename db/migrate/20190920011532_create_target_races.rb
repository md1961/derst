class CreateTargetRaces < ActiveRecord::Migration[5.2]

  def change
    create_table :target_races do |t|
      t.references :racer, null: false, foreign_key: true
      t.references :race , null: false, foreign_key: true

      t.timestamps
    end
  end
end
