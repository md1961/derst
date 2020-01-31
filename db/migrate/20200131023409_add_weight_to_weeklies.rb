class AddWeightToWeeklies < ActiveRecord::Migration[5.2]

  def change
    add_column :weeklies, :weight, :integer
  end
end
