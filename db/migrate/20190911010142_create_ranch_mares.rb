class CreateRanchMares < ActiveRecord::Migration[5.2]

  def change
    create_table :ranch_mares do |t|
      t.references :ranch, null: false, foreign_key: true
      t.references :mare , null: false, foreign_key: true
      t.integer    :year_birth

      t.timestamps
    end
  end
end
