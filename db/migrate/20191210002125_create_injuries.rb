class CreateInjuries < ActiveRecord::Migration[5.2]

  def change
    create_table :injuries do |t|
      t.references :racer      , foreign_key: true
      t.string     :description, null: false

      t.timestamps
    end
  end
end
