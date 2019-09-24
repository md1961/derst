[
  Course,
  Area
].each do |model|
  model.destroy_all
end

[
  ['Hokkaido', 0],
  ['Tohoku'  , 2],
  ['Kanto'   , 4],
  ['Chubu'   , 6],
  ['Kansai'  , 5],
  ['Kyushu'  , 7]
].each do |name, location|
  Area.create!(name: name, location: location)
end

[
  %w[札幌 Hokkaido],
  %w[函館 Hokkaido],
  %w[福島 Tohoku],
  %w[新潟 Chubu],
  %w[中山 Kanto],
  %w[東京 Kanto left],
  %w[中京 Chubu left],
  %w[京都 Kansai],
  %w[阪神 Kansai],
  %w[小倉 Kyushu],
].each do |name, area_name, left|
  area = Area.find_by(name: area_name)
  Course.create!(name: name, area: area, is_clockwise: left.nil?)
end
