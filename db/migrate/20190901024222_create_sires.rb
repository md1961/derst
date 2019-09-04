class CreateSires < ActiveRecord::Migration[5.2]

  def change
    create_table :sires do |t|
      t.string     :name_jp
      t.string     :name_eng
      t.integer    :father_id
      t.references :root_lineage, foreign_key: true

      t.timestamps
    end
  end
end
