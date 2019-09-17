class CreateResults < ActiveRecord::Migration[5.2]

  def change
    create_table :results do |t|
      t.references :racer, null: false, foreign_key: true
      t.references :race , null: false, foreign_key: true
      t.integer :ordering
      t.string  :surface_condition
      t.integer :num_racers
      t.integer :num_frame
      t.integer :rank_odds
      t.float   :odds
      t.integer :place
      t.integer :weight
      t.string  :mark_development
      t.string  :mark_stamina
      t.string  :mark_contend
      t.string  :mark_temper
      t.string  :mark_odds
      t.integer :age
      t.integer :load
      t.references :jockey, foreign_key: true
      t.string  :for_bad_surface
      t.string  :position
      t.string  :direction
      t.string  :comment_paddock
      t.string  :comment_race

      t.timestamps
    end
  end
end
