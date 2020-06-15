class CreateHandicapLoads < ActiveRecord::Migration[5.2]
  def change
    create_table :handicap_loads do |t|
      t.references :racer, foreign_key: true
      t.references :grade, foreign_key: true
      t.integer :load

      t.timestamps
    end
  end
end
