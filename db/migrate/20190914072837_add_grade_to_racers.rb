class AddGradeToRacers < ActiveRecord::Migration[5.2]

  def change
    add_column :racers, :grade_id, :integer
  end
end
