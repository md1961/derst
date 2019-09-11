class CreateJockeys < ActiveRecord::Migration[5.2]

  def change
    create_table :jockeys do |t|
      t.string     :name  , null: false
      t.references :stable, foreign_key: true

      t.timestamps
    end
  end
end
