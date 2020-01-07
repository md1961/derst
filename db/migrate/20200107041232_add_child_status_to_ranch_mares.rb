class AddChildStatusToRanchMares < ActiveRecord::Migration[5.2]

  def change
    add_column :ranch_mares, :child_status, :integer, null: false, default: 0
  end
end
