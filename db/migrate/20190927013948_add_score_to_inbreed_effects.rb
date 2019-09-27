class AddScoreToInbreedEffects < ActiveRecord::Migration[5.2]

  def change
    add_column :inbreed_effects, :score, :integer, null: false, default: 0
  end
end
