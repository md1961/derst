month = 11

Race.where(month: month).destroy_all

[
  %w[1 東京 3 n nil 1600 t 0 a 0],
  %w[1 東京 3 m nil 1800 t 0 a 0],
  %w[1 東京 3 5 百日草特別 1600 t 0 a 0],
  %w[1 東京 4u 5 nil 1600 t 0 a 0],
  %w[1 東京 4u 5 河口湖特別 2300 t 0 a 0],
  %w[1 東京 4u 9 nil 1600 d 0 a 0],
  %w[1 東京 4u 9 鷹巣山特別 1400 t 0 h 0],
  %w[1 東京 4u 16 ユートピアS 1400 t f a 0],
  %w[1 東京 4u g2 アルゼンチン共和国杯 2500 t 0 h 0],
  %w[1 京都 3 n nil 1400 t 0 a 0],
  %w[1 京都 3 m nil 1400 d 0 a 0],
  %w[1 京都 3 g3 ファンタジーS 1400 t f a 0],
  %w[1 京都 4u 5 nil 1400 d f a 0],
  %w[1 京都 4u 5 舞鶴特別 2400 t 0 a 0],
  %w[1 京都 4u 9 nil 1800 d 0 a 0],
  %w[1 京都 4u 9 東山特別 1600 t 0 a 0],
  %w[1 京都 4u 16 清水S 1600 t 0 a 0],
  %w[1 京都 4 g1 菊花賞 3000 t 0 c 0],
  %w[1 福島 3 n nil 1000 t 0 a 0],
  %w[1 福島 3 m nil 1200 t 0 a 0],
  %w[1 福島 4u m nil 1000 d 0 a 0],
  %w[1 福島 4u m nil 2000 t 0 a 0],
  %w[1 福島 4u 5 伊達特別 1700 d 0 a 0],
  %w[1 福島 4u 5 相馬特別 1800 t f a 0],
  %w[1 福島 4u 9 みちのく特別 2600 t 0 a 0],
  %w[1 福島 4u o 福島民友C 1800 t 0 s 0],
  %w[2 東京 3 n nil 1200 d 0 a 0],
  %w[2 東京 3 m nil 1400 t 0 a 0],
  %w[2 東京 3 5 nil 1200 d 0 a 0],
  %w[2 東京 3 g2 京成杯３歳S 1400 t 0 a 0],
  %w[2 東京 4u 5 nil 1400 d 0 a 0],
  %w[2 東京 4u 9 nil 1400 t 0 a 0],
  %w[2 東京 4u 9 TVKテレビ賞 2400 t 0 h 0],
  %w[2 東京 4u 16 霜月S 1600 d 0 h 0],
  %w[2 東京 4u g3 根岸S 1200 d 0 s 0],
  %w[2 京都 3 n nil 1600 t 0 a 0],
  %w[2 京都 3 m nil 1400 t 0 a 0],
  %w[2 京都 3 5 かえで賞 1200 t 0 a 0],
  %w[2 京都 3 o 京都３歳S 1800 t 0 s 0],
  %w[2 京都 4u 5 nil 1800 d 0 a 0],
  %w[2 京都 4u 9 nil 1200 d 0 a 0],
  %w[2 京都 4u 9 醍醐特別 1800 t 0 a 0],
  %w[2 京都 4u 16 ドンカスターS 1200 t 0 h 0],
  %w[2 京都 4u g1 エリザベス女王杯 2200 t f c 0],
  %w[2 福島 3 n nil 1200 t 0 a 0],
  %w[2 福島 3 m nil 1000 d 0 a 0],
  %w[2 福島 4u m nil 1700 d 0 a 0],
  %w[2 福島 4u m nil 1800 t f a 0],
  %w[2 福島 4u m nil 1200 t 0 a 0],
  %w[2 福島 4u 5 金華山特別 1000 d 0 a 0],
  %w[2 福島 4u 5 会津特別 1800 t 0 a 0],
  %w[2 福島 4u 9 河北新報杯 1800 t 0 h 0],
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
