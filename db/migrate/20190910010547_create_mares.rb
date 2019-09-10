class CreateMares < ActiveRecord::Migration[5.2]

  def change
    create_table :mares do |t|
      t.string     :name     , null: false
      t.integer    :father_id
      t.references :lineage  , foreign_key: true
      t.integer    :price
      t.integer    :speed
      t.integer    :stamina
      t.boolean    :has_child
      t.string     :rating
      t.string     :type

      t.timestamps
    end
  end
end
