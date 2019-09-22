class CreatePostRaces < ActiveRecord::Migration[5.2]

  def change
    create_table :post_races do |t|
      t.references :result , foreign_key: true
      t.string     :comment

      t.timestamps
    end
  end
end
