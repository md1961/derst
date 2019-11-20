class AddRemarkToRanchMares < ActiveRecord::Migration[5.2]

  def change
    add_column :ranch_mares, :remark, :string
  end
end
