prizes = nil
open('db/high_race_prizes.txt') do |f|
  ApplicationRecord.transaction do
    f.each do |line|
      line.chomp!
      items = line.split
      raise "Number of items should be 9 (#{items.size})" unless items.size == 9

      race = Race.find(items[0])
      raise "Cannot find Race with id of #{items[0]}" unless race
      p1, p2 = items[-2 .. -1].map(&:to_i)
      raise "Illegal prizes (#{p1}, #{p2})" if p1 < 3200 || p2 < 1300

      pattern = PrizePattern.all.detect { |pp|
        pp.prizes.find_by(place: 1)&.amount == p1 && pp.prizes.find_by(place: 2)&.amount == p2
      }
      unless pattern
        pattern = PrizePattern.create!.tap { |pp|
          pp.prizes.create!(place: 1, amount: p1)
          pp.prizes.create!(place: 2, amount: p2)
        }
      end

      race.update!(prize_pattern: pattern)
    end
  end
end
