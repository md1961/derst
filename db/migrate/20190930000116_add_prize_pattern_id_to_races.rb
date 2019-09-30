class AddPrizePatternIdToRaces < ActiveRecord::Migration[5.2]

  def change
    add_reference :races, :prize_pattern, foreign_key: true
  end
end
