class CreateStables < ActiveRecord::Migration[5.2]

  def change
    create_table :stables do |t|
      t.string     :name  , null: false
      t.references :center, null: false, foreign_key: true
      t.string     :description

      t.timestamps
    end
  end
end
