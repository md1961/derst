open('db/high_race_prizes.txt') do |f|
  f.each do |line|
    line.chomp!
    items = line.split
    raise "Number of items should be 9 (#{items.size})" unless items.size == 9

    race = Race.find(items[0])
    raise "Cannot find Race with id of #{items[0]}" unless race
    p1, p2 = items[-2 .. -1].map(&:to_i)
    raise "Illegal prizes (#{p1}, #{p2})" if p1 < 3200 || p2 < 1300

    pattern = race.prize_pattern
    prize1 = pattern.prizes.find_by(place: 1)&.amount
    prize2 = pattern.prizes.find_by(place: 2)&.amount
    raise "Prize mismatch for Race with id of #{race.id}" unless p1 == prize1 && p2 == prize2
  end
end
