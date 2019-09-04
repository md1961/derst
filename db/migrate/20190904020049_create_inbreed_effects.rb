class CreateInbreedEffects < ActiveRecord::Migration[5.2]

  def change
    create_table :inbreed_effects do |t|
      t.string :name, null: false
      t.string :abbr

      t.timestamps
    end
  end
end
