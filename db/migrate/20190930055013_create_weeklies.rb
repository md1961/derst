class CreateWeeklies < ActiveRecord::Migration[5.2]

  def change
    create_table :weeklies do |t|
      t.references :racer    , null: false, foreign_key: true
      t.integer    :age      , null: false
      t.integer    :month    , null: false
      t.integer    :week     , null: false
      t.string     :condition

      t.timestamps
    end
  end
end
