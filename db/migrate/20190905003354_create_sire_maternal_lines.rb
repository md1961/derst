class CreateSireMaternalLines < ActiveRecord::Migration[5.2]

  def change
    create_table :sire_maternal_lines do |t|
      t.references :sire      , null: false, foreign_key: true
      t.integer    :generation, null: false
      t.integer    :father_id , null: false

      t.timestamps
    end
  end
end
