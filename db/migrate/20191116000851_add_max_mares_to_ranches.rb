class AddMaxMaresToRanches < ActiveRecord::Migration[5.2]

  def change
    add_column :ranches, :max_mares, :integer, null: false, default: 2
  end
end
