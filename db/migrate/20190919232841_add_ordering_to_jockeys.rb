class AddOrderingToJockeys < ActiveRecord::Migration[5.2]

  def change
    add_column :jockeys, :ordering, :integer
  end
end
