class AddGradeGivenIdToRacers < ActiveRecord::Migration[5.2]

  def change
    add_column :racers, :grade_given_id, :integer

    Racer.all.each do |racer|
      racer.update!(grade_given_id: racer.grade_id)
      racer.update!(grade_id: nil)
    end
  end
end
