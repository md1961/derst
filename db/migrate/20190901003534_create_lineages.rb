class CreateLineages < ActiveRecord::Migration[5.2]

  def change
    create_table :lineages do |t|
      t.string :name    , null: false
      t.string :name_eng

      t.timestamps
    end
  end
end
