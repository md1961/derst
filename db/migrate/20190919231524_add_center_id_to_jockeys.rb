class AddCenterIdToJockers < ActiveRecord::Migration[5.2]

  def change
    add_reference :jockeys, :center, foreign_key: true
  end
end
