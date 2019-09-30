class CreatePrizes < ActiveRecord::Migration[5.2]

  def change
    create_table :prizes do |t|
      t.references :prize_pattern, null: false, foreign_key: true
      t.integer    :place        , null: false
      t.integer    :amount       , null: false

      t.timestamps
    end
  end
end
