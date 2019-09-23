class AddIsActiveToRacers < ActiveRecord::Migration[5.2]

  def change
    add_column :racers, :is_active, :boolean, null: false, default: true
  end
end
