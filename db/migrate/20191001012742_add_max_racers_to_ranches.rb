class AddMaxRacersToRanches < ActiveRecord::Migration[5.2]

  def change
    add_column :ranches, :max_racers, :integer, null: false, default: 6
  end
end
