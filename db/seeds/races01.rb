month = 1

Race.where(month: 1).destroy_all

[
  %w[1 1 中山 4 m nil nil 0 d 1200 a 0],
  %w[1 1 中山 4 m nil nil 0 d 1800 a 0],
  %w[1 1 中山 4 5 nil nil 0 d 1800 a 0],
  %w[1 1 中山 4 5 若竹賞 nil 0 t 2000 a 0],
  %w[1 1 中山 5u 5 nil nil 0 d 2400 a 0],
  %w[1 1 中山 5u 9 nil nil 0 d 1200 a 0],
  %w[1 1 中山 5u 9 成田特別 nil 0 d 2400 a 0],
  %w[1 1 中山 5u 16 迎春S nil 0 t 2500 a 0],
  %w[1 1 中山 5u g3 中山金杯 nil 0 t 2000 h 0],
  %w[1 1 京都 4 m nil nil 0 d 1200 a 0],
  %w[1 1 京都 4 m nil nil 0 d 1800 a 0],
  %w[1 1 京都 4 5 福寿草特別 nil 0 t 2000 a 0],
  %w[1 1 京都 4 o 紅梅賞 nil 1 t 1200 s 0],
  %w[1 1 京都 5u 5 nil nil 0 d 1400 a 0],
  %w[1 1 京都 5u 9 nil nil 0 d 1200 a 0],
  %w[1 1 京都 5u 9 伏見特別 nil 0 t 1600 a 0],
  %w[1 1 京都 5u 16 門松S nil 0 d 1400 a 0],
  %w[1 1 京都 5u g3 京都金杯 nil 0 t 2000 h 0],
  %w[1 2 中山 4 m nil nil 0 d 1800 a 0],
  %w[1 2 中山 4 m nil nil 0 t 1800 a 0],
  %w[1 2 中山 4 5 朱竹賞 nil 0 d 1200 a 0],
  %w[1 2 中山 4 g3 京成杯 nil 0 t 1600 s 0],
  %w[1 2 中山 5u 5 nil nil 0 d 1200 a 0],
  %w[1 2 中山 5u 9 nil nil 2 d 1800 a 0],
  %w[1 2 中山 5u 9 若水賞 nil 0 d 1200 a 0],
  %w[1 2 中山 5u 16 アレキサンドS nil 0 d 1800 a 0],
  %w[1 2 中山 5u o ニューイヤーS nil 0 t 1600 s 0],
  %w[1 2 京都 4 m nil nil 2 d 1400 a 0],
  %w[1 2 京都 4 m nil nil 0 d 1800 a 0],
  %w[1 2 京都 4 5 nil nil 0 d 1800 a 0],
  %w[1 2 京都 4 5 若菜賞 nil 0 t 1400 a 0],
  %w[1 2 京都 5u 5 nil nil 0 d 1800 a 0],
  %w[1 2 京都 5u 9 nil nil 0 d 1400 a 0],
  %w[1 2 京都 5u 9 睦月賞 nil 0 t 2400 a 0],
  %w[1 2 京都 5u 16 寿S nil 0 t 1600 a 0],
  %w[1 2 京都 5u g3 平安S nil 0 d 1800 s 0],
  %w[1 3 中山 4 m nil nil 0 d 1200 a 0],
  %w[1 3 中山 4 m nil nil 2 d 1800 a 0],
  %w[1 3 中山 4 5 黒竹賞 nil 0 d 1600 a 0],
  %w[1 3 中山 4 o フローラS nil 1 t 1200 a 0],
  %w[1 3 中山 5u 5 nil nil 0 d 1800 a 0],
  %w[1 3 中山 5u 9 nil nil 0 d 1800 a 0],
  %w[1 3 中山 5u 9 初春賞 nil 0 t 2500 a 0],
  %w[1 3 中山 5u 16 初富士S nil 0 t 1600 h 0],
  %w[1 3 中山 5u g3 ガーネットS nil 0 d 1200 s 0],
  %w[1 3 京都 4 m nil nil 0 d 1400 a 0],
  %w[1 3 京都 4 m nil nil 0 d 1800 a 0],
  %w[1 3 京都 4 5 寒梅賞 nil f d 1400 a 0],
  %w[1 3 京都 4 g3 シンザン記念 nil 0 t 1600 s 0],
  %w[1 3 京都 5u 5 nil nil 0 d 1200 a 0],
  %w[1 3 京都 5u 9 nil nil 0 d 1800 a 0],
  %w[1 3 京都 5u 9 八坂特別 nil 0 d 1400 a 0],
  %w[1 3 京都 5u 16 雅S nil 0 t 1800 h 0],
  %w[1 3 京都 5u o 洛陽S nil 0 t 1600 s 0],
  %w[1 4 中山 4 m nil nil f d 1200 a 0],
  %w[1 4 中山 4 m nil nil 0 d 1800 a 0],
  %w[1 4 中山 4 5 呉竹賞 nil 0 t 1200 a 0],
  %w[1 4 中山 4 o ジュニアC nil 0 t 2000 s 0],
  %w[1 4 中山 5u 5 nil nil 0 d 1200 a 0],
  %w[1 4 中山 5u 9 nil nil 0 d 1200 a 0],
  %w[1 4 中山 5u 9 若潮賞 nil 0 t 1800 h 0],
  %w[1 4 中山 5u 16 ジャニュアリーS nil 0 t 2000 h 0],
  %w[1 4 中山 5u g2 AJCC nil 0 t 2200 s 0],
  %w[1 4 京都 4 m nil nil 0 d 1200 a 0],
  %w[1 4 京都 4 m nil nil f d 1800 a 0],
  %w[1 4 京都 4 5 白梅賞 nil 0 d 1800 a 0],
  %w[1 4 京都 4 o 若駒S nil 0 t 2000 s 0],
  %w[1 4 京都 5u 5 nil nil 0 d 1800 a 0],
  %w[1 4 京都 5u 9 nil nil 0 d 1200 a 0],
  %w[1 4 京都 5u 9 稲荷特別 nil 0 t 1800 a 0],
  %w[1 4 京都 5u 16 石清水S nil 0 t 1200 a 0],
  %w[1 4 京都 5u g2 日経新春杯 nil 0 t 2400 h 0],
  # enum limitation: {unrestricted: 0, female_only: 1, domestic_only: 2}
  # age constant separate handicap

  #%w[5 3 東京 4 g1 日本ダービー ダービー 0 t 2400 a 5000],
].each do |month, week, course_name, age, grade_name, name, abbr,
            limitation, surface, distance, weight, prize1|
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
