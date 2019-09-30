class CreatePrizePatterns < ActiveRecord::Migration[5.2]

  def change
    create_table :prize_patterns do |t|
      t.timestamps
    end
  end
end
