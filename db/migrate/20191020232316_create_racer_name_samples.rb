class CreateRacerNameSamples < ActiveRecord::Migration[5.2]

  def change
    create_table :racer_name_samples do |t|
      t.string  :name    , null: false
      t.boolean :is_crown, null: false, default: false

      t.timestamps
    end
  end
end
