class AddIsInSpaToInRanches < ActiveRecord::Migration[5.2]

  def change
    add_column :in_ranches, :is_in_spa, :boolean, null: false, default: false
  end
end
