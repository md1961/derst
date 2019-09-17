month = 12

Race.where(month: month).destroy_all

[
  %w[1 中山 3 n nil 1200 t 0 a 0],
  %w[1 中山 3 n nil 1800 t 0 a 0],
  %w[1 中山 3 m nil 1200 d 0 a 0],
  %w[1 中山 3 5 葉牡丹賞 2000 t 0 a 0],
  %w[1 中山 4u 5 nil 1800 d 0 a 0],
  %w[1 中山 4u 9 nil 2600 t 0 a 0],
  %w[1 中山 4u 9 初霜特別 1200 d 0 a 0],
  %w[1 中山 4u 16 仲冬S 1200 t 0 h 0],
  %w[1 中山 4u g2 ステイヤーズS 3600 t 0 s 0],
  %w[1 阪神 3 n nil 1400 d 0 a 0],
  %w[1 阪神 3 m nil 1400 t 0 a 0],
  %w[1 阪神 3 5 さざんか賞 1400 t 0 a 0],
  %w[1 阪神 3 g1 阪神３歳牝馬S 1600 t f a 0],
  %w[1 阪神 4u 5 nil 1800 d 0 a 0],
  %w[1 阪神 4u 9 nil 2200 t 0 a 0],
  %w[1 阪神 4u 9 ゴールデンサドルT 1600 t 0 a 0],
  %w[1 阪神 4u 16 ゴールデンスパーT 1400 t 0 a 0],
  %w[1 阪神 4u 16 ゴールデンホイップT 2000 t 0 a 0],
  %w[1 中京 3 n nil 1200 t 0 a 0],
  %w[1 中京 3 m nil 1000 d 0 a 0],
  %w[1 中京 3 5 つわぶき賞 1800 t 0 a 0],
  %w[1 中京 4u 5 nil 1700 d f a 0],
  %w[1 中京 4u 5 nil 1800 t 0 a 0],
  %w[1 中京 4u 5 犬山特別 2000 t 0 a 0],
  %w[1 中京 4u 9 豊明特別 2000 t 0 h 0],
  %w[1 中京 4u g2 CBC賞 1200 t 0 s 0],
  %w[2 中山 3 n nil 1600 t 0 a 0],
  %w[2 中山 3 m nil 1800 d 0 a 0],
  %w[2 中山 3 5 黒松賞 1200 t 0 a 0],
  %w[2 中山 3 g1 朝日杯３歳S 1600 t 0 a 0],
  %w[2 中山 4u 5 nil 1200 d 0 a 0],
  %w[2 中山 4u 9 nil 1800 d 0 a 0],
  %w[2 中山 4u 9 清澄特別 1600 t 0 a 0],
  %w[2 中山 4u 16 市川S 1600 t 0 a 0],
  %w[2 中山 4u o ターコイズS 1800 t f h 0],
  %w[2 阪神 3 n nil 1600 t 0 a 0],
  %w[2 阪神 3 m nil 2000 t 0 a 0],
  %w[2 阪神 3 5 エリカ賞 2000 t 0 a 0],
  %w[2 阪神 4u 5 nil 1200 d 0 a 0],
  %w[2 阪神 4u 9 nil 1200 d f a 0],
  %w[2 阪神 4u 9 夙川特別 1400 d 0 h 0],
  %w[2 阪神 4u 16 オリオンS 2500 t 0 a 0],
  %w[2 阪神 4u o ポートアイランドS 1600 t 0 s 0],
  %w[2 阪神 4u g3 シリウスS 1400 d 0 h 0],
  %w[2 中京 3 n nil 1000 d 0 a 0],
  %w[2 中京 3 n nil 1800 t 0 a 0],
  %w[2 中京 3 m nil 1800 t 0 a 0],
  %w[2 中京 4u 5 nil 1000 d 0 a 0],
  %w[2 中京 4u 5 nil 2300 d 0 a 0],
  %w[2 中京 4u 5 揖斐川特別 2500 t 0 a 0],
  %w[2 中京 4u 9 伊吹山特別 1200 t 0 h 0],
  %w[2 中京 4u g2 ウインターS 2300 t 0 s 0],
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
