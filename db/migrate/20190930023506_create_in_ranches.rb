class CreateInRanches < ActiveRecord::Migration[5.2]

  def change
    create_table :in_ranches do |t|
      t.references :racer, null: false, foreign_key: true
      t.integer    :month, null: false
      t.integer    :week , null: false

      t.timestamps
    end
  end
end
