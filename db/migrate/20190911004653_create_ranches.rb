class CreateRanches < ActiveRecord::Migration[5.2]

  def change
    create_table :ranches do |t|
      t.string  :name
      t.integer :year
      t.integer :month
      t.integer :week

      t.timestamps
    end
  end
end
