class CreateRaces < ActiveRecord::Migration[5.2]

  def change
    create_table :races do |t|
      t.integer    :month  , null: false
      t.integer    :week   , null: false
      t.references :course , null: false, foreign_key: true
      t.string     :age    , null: false
      t.references :grade  , null: false, foreign_key: true
      t.string     :name
      t.string     :abbr
      t.boolean    :is_turf, null: false, default: true
      t.integer    :weight , null: false
      t.integer    :prize1

      t.timestamps
    end
  end
end
