class CreateGrades < ActiveRecord::Migration[5.2]

  def change
    create_table :grades do |t|
      t.string  :name    , null: false
      t.string  :abbr
      t.integer :ordering, null: false

      t.timestamps
    end
  end
end
