class CreateSireTraits < ActiveRecord::Migration[5.2]

  def change
    create_table :sire_traits do |t|
      t.references :sire        , null: false, foreign_key: true
      t.references :lineage     , null: false, foreign_key: true
      t.integer    :fee         , null: false
      t.integer    :min_distance, null: false
      t.integer    :max_distance, null: false
      t.string     :dirt        , null: false
      t.string     :growth      , null: false
      t.string     :temper      , null: false
      t.string     :contend     , null: false
      t.string     :health      , null: false
      t.string     :achievement , null: false
      t.string     :stability   , null: false

      t.timestamps
    end
  end
end
