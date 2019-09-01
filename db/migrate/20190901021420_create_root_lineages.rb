class CreateRootLineages < ActiveRecord::Migration[5.2]

  def change
    create_table :root_lineages do |t|
      t.integer :number  , null: false
      t.string  :name    , null: false
      t.string  :name_eng

      t.timestamps
    end
  end
end
