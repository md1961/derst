class CreateRacers < ActiveRecord::Migration[5.2]

  def change
    create_table :racers do |t|
      t.string     :name        , null: false
      t.references :ranch       , null: false, foreign_key: true
      t.integer    :year_birth
      t.string     :comment_age2
      t.string     :comment_age3
      t.references :stable      , foreign_key: true
      t.integer    :weight_fat
      t.integer    :weight_best
      t.integer    :weight_lean

      t.timestamps
    end
  end
end
