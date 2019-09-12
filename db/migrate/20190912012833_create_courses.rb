class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string     :name        , null: false
      t.references :area        , null: false, foreign_key: true
      t.boolean    :is_clockwise, null: false, default: true

      t.timestamps
    end
  end
end
