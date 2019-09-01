class CreateLineages < ActiveRecord::Migration[5.2]

  def change
    create_table :lineages do |t|
      t.string :name
      t.string :name_eng

      t.timestamps
    end
  end
end
