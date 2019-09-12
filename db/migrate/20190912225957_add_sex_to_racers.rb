class AddSexToRacers < ActiveRecord::Migration[5.2]

  def change
    add_column :racers, :sex, :integer
  end
end
