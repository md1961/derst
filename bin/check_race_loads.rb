open('db/loads_constant.txt') do |f|
  f.each do |line|
    line.chomp!
    next if line.empty?
    mw, name, *loads = line.split
    race = Race.find_by(name: name)
    next if race.age == '4'
    a_attrs = [
      {ranch_id: 1, year_birth: 4, sex: 1},
      {ranch_id: 1, year_birth: 3, sex: 1},
      {ranch_id: 1, year_birth: 2, sex: 1},
      {ranch_id: 1, year_birth: 4, sex: 2},
      {ranch_id: 1, year_birth: 3, sex: 2},
      {ranch_id: 1, year_birth: 2, sex: 2},
    ]
    printf("%4s %2s: %s\t\t%2d %2d %2d  %2d %2d %2d\n", mw, race.age, loads.join(' '),
           *a_attrs.map { |attrs| race.load_for(Racer.new(attrs)) }.map(&:to_i))
  end
end
