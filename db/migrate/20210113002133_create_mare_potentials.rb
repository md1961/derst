class CreateMarePotentials < ActiveRecord::Migration[5.2]

  def change
    create_table :mare_potentials do |t|
      t.references :mare, null: false, foreign_key: true
      t.integer    :count_nicks
      t.integer    :count_interesting
      t.integer    :count_nicks_and_interesting

      t.timestamps
    end
  end
end
