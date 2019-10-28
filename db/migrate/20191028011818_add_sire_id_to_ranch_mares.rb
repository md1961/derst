class AddSireIdToRanchMares < ActiveRecord::Migration[5.2]

  def change
    add_reference :ranch_mares, :sire, foreign_key: true
  end
end
