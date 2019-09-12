class CreateInbreedCaches < ActiveRecord::Migration[5.2]

  def change
    create_table :inbreed_caches do |t|
      t.references :mare, null: false, foreign_key: true
      t.references :sire, null: false, foreign_key: true
      t.string     :h_inbreeds_in_json

      t.timestamps
    end
  end
end
