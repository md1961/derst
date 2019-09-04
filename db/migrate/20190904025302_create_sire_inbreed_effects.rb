class CreateSireInbreedEffects < ActiveRecord::Migration[5.2]

  def change
    create_table :sire_inbreed_effects do |t|
      t.references :sire          , null: false, foreign_key: true
      t.references :inbreed_effect, null: false, foreign_key: true

      t.timestamps
    end
  end
end
