month = 9

Race.where(month: month).destroy_all

[
  %w[1 中山 3 n nil 1200 t 0 a 0],
  %w[1 中山 3 m nil 1600 t 0 a 0],
  %w[1 中山 4u m nil 2000 t 0 a 0],
  %w[1 中山 4u 5 nil 1600 t 0 a 0],
  %w[1 中山 4u 5 葛飾特別 1200 t 0 a 0],
  %w[1 中山 4u 9 nil 1800 d 0 a 0],
  %w[1 中山 4u 9 浦安特別 1600 t 0 a 0],
  %w[1 中山 4u 16 初風S 1800 d 0 a 0],
  %w[1 中山 4u g3 京王杯AH 1600 t 0 h 0],
  %w[1 阪神 3 n nil 1200 t 0 a 0],
  %w[1 阪神 3 m nil 1200 t 0 a 0],
  %w[1 阪神 4u m nil 1800 d 0 a 0],
  %w[1 阪神 4u 5 nil 2200 t 0 a 0],
  %w[1 阪神 4u 5 箕面特別 1200 t 0 a 0],
  %w[1 阪神 4u 9 nil 2200 t 0 a 0],
  %w[1 阪神 4u 9 芦屋川特別 1200 t 0 a 0],
  %w[1 阪神 4u 16 ムーンライトH 1600 t 0 h 0],
  %w[1 阪神 4u g3 朝日杯チャレンジC 2000 t 0 s 0],
  %w[1 札幌 3 n nil 1800 t 0 a 0],
  %w[1 札幌 3 n nil 1000 t 0 a 0],
  %w[1 札幌 4u m nil 1700 d 0 a 0],
  %w[1 札幌 4u m nil 1200 t 0 a 0],
  %w[1 札幌 4u 5 nil 1700 d 0 a 0],
  %w[1 札幌 4u 5 積丹特別 2600 t 0 a 0],
  %w[1 札幌 4u 9 ポプラS 1800 t 0 h 0],
  %w[1 札幌 4u o キーンランドC 1000 t 0 s 0],
  %w[2 中山 3 n nil 1600 t 0 a 0],
  %w[2 中山 3 m nil 1200 t 0 a 0],
  %w[2 中山 4u m nil 1200 d 0 a 0],
  %w[2 中山 4u 5 nil 1200 t f a 0],
  %w[2 中山 4u 5 佐倉特別 2500 t 0 a 0],
  %w[2 中山 4u 9 nil 1800 t f a 0],
  %w[2 中山 4u 9 利根川特別 1200 d 0 a 0],
  %w[2 中山 4u 16 ニューマーケットC 2000 t 0 h 0],
  %w[2 中山 4u g2 オールカマー 2200 t 0 s 0],
  %w[2 阪神 3 n nil 1600 t d a 0],
  %w[2 阪神 3 m nil 1200 d 0 a 0],
  %w[2 阪神 3 o 野路菊S 1600 t 0 s 0],
  %w[2 阪神 4u m nil 1600 t 0 a 0],
  %w[2 阪神 4u 5 nil 1800 d f a 0],
  %w[2 阪神 4u 5 西脇特別 2000 t 0 a 0],
  %w[2 阪神 4u 9 nil 1200 t f a 0],
  %w[2 阪神 4u 9 新涼特別 1800 d 0 a 0],
  %w[2 阪神 4u g2 神戸新聞杯 2000 t 0 c 0],
  %w[2 札幌 3 n nil 1000 t 0 a 0],
  %w[2 札幌 3 n nil 1500 t 0 a 0],
  %w[2 札幌 4u m nil 1000 d 0 a 0],
  %w[2 札幌 4u m nil 2000 t 0 a 0],
  %w[2 札幌 4u 5 nil 1700 d f a 0],
  %w[2 札幌 4u 5 まりも特別 1200 t 0 a 0],
  %w[2 札幌 4u 9 阿寒湖特別 2000 t 0 a 0],
  %w[2 札幌 4u g3 エルムS 1700 d 0 s 0],
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
