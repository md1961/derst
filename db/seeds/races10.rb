month = 10

Race.where(month: month).destroy_all

[
  %w[1 東京 3 n nil 1600 t 0 a 0],
  %w[1 東京 3 m nil 1400 t 0 a 0],
  %w[1 東京 3 5 サフラン賞 1400 t f a 0],
  %w[1 東京 4u 5 nil 1600 t 0 a 0],
  %w[1 東京 4u 9 nil 1400 t 0 a 0],
  %w[1 東京 4u 9 錦秋特別 1600 d 0 a 0],
  %w[1 東京 4u 16 オクトーバーS 2300 t 0 a 0],
  %w[1 東京 4u g3 ユニコーンS 1600 d 0 c 0],
  %w[1 東京 4u g2 毎日王冠 1800 t 0 s 0],
  %w[1 京都 3 n nil 1800 t 0 a 0],
  %w[1 京都 3 m nil 1400 t 0 a 0],
  %w[1 京都 3 o もみじS 1600 t 0 s 0],
  %w[1 京都 4u 5 nil 1200 d f a 0],
  %w[1 京都 4u 5 nil 1800 t 0 a 0],
  %w[1 京都 4u 9 nil 1200 d 0 a 0],
  %w[1 京都 4u 9 嵯峨野特別 2200 t 0 a 0],
  %w[1 京都 4u 16 太秦S 1800 d 0 h 0],
  %w[1 京都 4u g2 京都大賞典 2400 t 0 s 0],
  %w[1 福島 3 n nil 1000 t 0 a 0],
  %w[1 福島 3 m nil 1200 t 0 a 0],
  %w[1 福島 4u m nil 1800 t f a 0],
  %w[1 福島 4u m nil 1700 d 0 a 0],
  %w[1 福島 4u m nil 1200 t 0 a 0],
  %w[1 福島 4u 5 二本松特別 1800 t 0 a 0],
  %w[1 福島 4u 5 松川浦特別 2000 t 0 a 0],
  %w[1 福島 4u o 福島民報杯 2000 t 0 s 0],
  %w[2 東京 3 n nil 1400 t 0 a 0],
  %w[2 東京 3 m nil 1200 d 0 a 0],
  %w[2 東京 3 o アイビーS 1400 t 0 s 0],
  %w[2 東京 4u 5 nil 1200 d 0 a 0],
  %w[2 東京 4u 5 nil 2000 t 0 a 0],
  %w[2 東京 4u 9 nil 2000 t 0 a 0],
  %w[2 東京 4u 9 赤富士賞 1600 t 0 h 0],
  %w[2 東京 4u 16 秀嶺S 1400 d 0 a 0],
  %w[2 東京 4u g3 府中牝馬S 1800 t f s 0],
  %w[2 京都 3 n nil 1200 t 0 a 0],
  %w[2 京都 3 m nil 1800 t 0 a 0],
  %w[2 京都 3 5 りんどう賞 1400 t f a 0],
  %w[2 京都 4u 5 nil 1400 d 0 a 0],
  %w[2 京都 4u 9 nil 1800 d 0 a 0],
  %w[2 京都 4u 9 壬生特別 1200 t 0 h 0],
  %w[2 京都 4u 16 嵐山S 3000 t 0 a 0],
  %w[2 京都 4u o オパールS 1200 t 0 h 0],
  %w[2 京都 4 g2 京都新聞杯 2200 t 0 c 0],
  %w[2 福島 3 n nil 1200 t 0 a 0],
  %w[2 福島 3 m nil 1700 t 0 a 0],
  %w[2 福島 4u m nil 1000 d 0 a 0],
  %w[2 福島 4u m nil 2000 t d a 0],
  %w[2 福島 4u m nil 1800 t 0 a 0],
  %w[2 福島 4u 5 桧原湖特別 1700 d 0 a 0],
  %w[2 福島 4u 5 勿来特別 1800 t f a 0],
  %w[2 福島 4u 9 福島中央テレビ杯 1800 t 0 h 0],
  # enum limitation: {unrestricted: 0, female_only: 1, domestic_only: 2}
  # age constant separate handicap
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
