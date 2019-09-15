month = 4

Race.where(month: month).destroy_all

[
  %w[1 中山 4 m nil 1200 d 0 a 0],
  %w[1 中山 4 m nil 1600 t 0 a 0],
  %w[1 中山 4 5 山吹賞 2200 t 0 a 0],
  %w[1 中山 4 o 若葉S 2000 t 0 c 0],
  %w[1 中山 5u 5 nil 1200 d 0 a 0],
  %w[1 中山 5u 9 nil 1200 d 0 a 0],
  %w[1 中山 5u 9 隅田川特別 2000 t 0 h 0],
  %w[1 中山 5u 16 春風S 1200 d 0 h 0],
  %w[1 中山 5u g2 日経賞 2500 t 0 s 0],
  %w[1 阪神 4 m nil 1800 d f a 0],
  %w[1 阪神 4 m nil 2000 t 0 a 0],
  %w[1 阪神 4 5 れんげ賞 1200 t 0 a 0],
  %w[1 阪神 4 g3 毎日杯 2000 t 0 s 0],
  %w[1 阪神 5u 5 nil 1800 d 0 a 0],
  %w[1 阪神 5u 9 nil 1200 d 0 a 0],
  %w[1 阪神 5u 9 姫路特別 1800 d 0 h 0],
  %w[1 阪神 5u 16 道頓堀S 1600 t 0 h 0],
  %w[1 阪神 5u o 陽春S 1800 d 0 s 0],
  %w[2 中山 4 m nil 1800 d d a 0],
  %w[2 中山 4 m nil 2200 t 0 a 0],
  %w[2 中山 4 5 山桜賞 1800 t 0 a 0],
  %w[2 中山 4 g3 クリスタルC 1200 t 0 s 0],
  %w[2 中山 5u 5 nil 1800 d 0 a 0],
  %w[2 中山 5u 9 nil 1800 d 0 a 0],
  %w[2 中山 5u 9 鹿島特別 2500 t 0 a 0],
  %w[2 中山 5u 16 アクアマリンS 1800 d 0 a 0],
  %w[2 中山 5u o エイプリルS 2000 t 0 s 0],
  %w[2 阪神 4 m nil 1200 d 0 a 0],
  %w[2 阪神 4 m nil 1400 t 0 a 0],
  %w[2 阪神 4 5 はなみずき賞 2200 t 0 a 0],
  %w[2 阪神 5u 5 nil 1200 d 0 a 0],
  %w[2 阪神 5u 9 nil 1800 d 0 a 0],
  %w[2 阪神 5u 9 播磨特別 1200 t f a 0],
  %w[2 阪神 5u 16 なにわS 2000 t 0 a 0],
  %w[2 阪神 5u g3 阪急杯 1200 t 0 h 0],
  %w[2 阪神 5u g2 産経大阪杯 2000 t 0 s 0],
  %w[3 中山 4 m nil 1200 d 0 a 0],
  %w[3 中山 4 m nil 2000 t 0 a 0],
  %w[3 中山 4 5 nil 1200 d 0 a 0],
  %w[3 中山 4 5 ミモザ賞 2000 t f a 0],
  %w[3 中山 5u 5 nil 1200 d 0 a 0],
  %w[3 中山 5u 9 nil 1200 d f a 0],
  %w[3 中山 5u 9 勝浦特別 1200 t 0 h 0],
  %w[3 中山 5u 16 船橋S 1600 t 0 h 0],
  %w[3 中山 5u g3 ダービー卿CT 1600 t 0 s 0],
  %w[3 阪神 4 m nil 1800 d 0 a 0],
  %w[3 阪神 4 m nil 1200 d d a 0],
  %w[3 阪神 4 5 君子蘭賞 1600 t 0 a 0],
  %w[3 阪神 4 g1 桜花賞 1600 t f c 0],
  %w[3 阪神 5u 5 nil 1200 d 0 a 0],
  %w[3 阪神 5u 9 nil 1800 d 0 a 0],
  %w[3 阪神 5u 9 摂津特別 2200 t 0 a 0],
  %w[3 阪神 5u 16 梅田S 1800 d 0 h 0],
  %w[3 阪神 5u o 大阪-ハンブルクC 2500 t 0 h 0],
  %w[4 中山 4 m nil 1200 t 0 a 0],
  %w[4 中山 4 m nil 1800 d 0 a 0],
  %w[4 中山 4 5 nil 1800 d 0 a 0],
  %w[4 中山 4 5 山藤賞 1600 t 0 a 0],
  %w[4 中山 4 g1 皐月賞 2000 t 0 c 0],
  %w[4 中山 5u 5 nil 1800 d 0 a 0],
  %w[4 中山 5u 9 nil 1600 t 0 a 0],
  %w[4 中山 5u 9 舞浜特別 1800 d 0 a 0],
  %w[4 中山 5u o 卯月S 1200 t 0 s 0],
  %w[4 阪神 4 m nil 1400 d 0 a 0],
  %w[4 阪神 4 m nil 2200 t 0 a 0],
  %w[4 阪神 4 5 アザレア賞 2000 t 0 a 0],
  %w[4 阪神 4 o 若草S 2200 t 0 s 0],
  %w[4 阪神 5u 5 nil 1800 d 0 a 0],
  %w[4 阪神 5u 9 nil 1200 d 0 a 0],
  %w[4 阪神 5u 9 赤穂特別 1400 t 0 a 0],
  %w[4 阪神 5u 16 難波S 2200 t 0 a 0],
  %w[4 阪神 5u g3 プロキオンS 1400 d 0 s 0],
  # enum limitation: {unrestricted: 0, female_only: 1, domestic_only: 2}
  # age constant separate handicap

  #%w[5 3 東京 4 g1 日本ダービー ダービー 0 t 2400 a 5000],
].each do |week, course_name, age, grade_name, name,
            distance, surface, limitation, weight, prize1|
  course = Course.find_by(name: course_name)
  raise "Cannot find Course '#{course_name}' for m#{month}-w#{week}" unless course

  grade_name.upcase!
  grade_name = '新' if grade_name == 'N'
  grade_name = '未' if grade_name == 'M'
  grade_name = 'OP' if grade_name == 'O'
  grade_name = 'Ⅲ' if grade_name == 'G3'
  grade_name = 'Ⅱ' if grade_name == 'G2'
  grade_name = 'Ⅰ' if grade_name == 'G1'
  grade = Grade.find_by(abbr: grade_name) || Grade.find_by(name: grade_name)
  raise "Cannot find Course '#{grade_name}' for m#{month}-w#{week}" unless grade

  abbr = nil if abbr == 'nil'

  weight = {a: 1, c: 2, s: 3, h: 4}[weight[0].downcase.to_sym]

  Race.create!(
    month:      month.to_i,
    week:       week.to_i,
    course:     course,
    age:        age.upcase,
    grade:      grade,
    name:       name == 'nil' ? nil : name,
    abbr:       abbr,
    limitation: limitation == 'f' ? 1 : limitation == 'd' ? 2 : limitation.to_i,
    surface:    surface.downcase == 'd' ? 1 : 0,
    distance:   distance.to_i,
    weight:     weight,
    prize1:     prize1 && prize1.to_i
  )
end
