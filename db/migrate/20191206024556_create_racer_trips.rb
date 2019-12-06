class CreateRacerTrips < ActiveRecord::Migration[5.2]

  def change
    create_table :racer_trips do |t|
      t.references :racer , foreign_key: true
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
