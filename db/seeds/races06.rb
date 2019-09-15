month = 6

Race.where(month: month).destroy_all

[
  %w[1 東京 4 m nil 1600 d f a 0],
  %w[1 東京 4 m nil 1800 t 0 a 0],
  %w[1 東京 4 5 nil 1400 d 0 a 0],
  %w[1 東京 4 5 くちなし賞 2400 t 0 a 0],
  %w[1 東京 5u 5 nil 2300 t 0 a 0],
  %w[1 東京 5u 9 nil 1600 d 0 a 0],
  %w[1 東京 5u 9 石和特別 1400 t 0 a 0],
  %w[1 東京 5u 16 フリーウェイS 1400 t 0 a 0],
  %w[1 東京 5u g3 武蔵野S 2100 d 0 h 0],
  %w[1 中京 4 m nil 1600 d f a 0],
  %w[1 中京 4 m nil 1200 t 0 a 0],
  %w[1 中京 4 5 nil 1700 d 0 a 0],
  %w[1 中京 4 5 なでしこ賞 1200 t 0 a 0],
  %w[1 中京 4 9 白藤S 2000 t 0 a 0],
  %w[1 中京 5u 5 nil 2500 t 0 a 0],
  %w[1 中京 5u 9 浜名湖特別 1800 t 0 h 0],
  %w[1 中京 5u 16 桶狭間S 1200 t 0 a 0],
  %w[1 中京 4u g1 高松宮杯 1200 t 0 c 0],
  %w[2 東京 4 m nil 2100 d 0 a 0],
  %w[2 東京 4 m nil 1400 t 0 a 0],
  %w[2 東京 4 5 nil 1600 d 0 a 0],
  %w[2 東京 4 5 ロベリア賞 1800 t 0 a 0],
  %w[2 東京 4 g1 オークス 2400 t f c 0],
  %w[2 東京 5u 5 nil 1400 t 0 a 0],
  %w[2 東京 5u 9 nil 1600 t 0 a 0],
  %w[2 東京 5u 9 青嵐賞 2400 t 0 a 0],
  %w[2 東京 5u 16 箱根S 2000 t 0 a 0],
  %w[2 中京 4 m nil 1000 d 0 a 0],
  %w[2 中京 4 m nil 2500 t 0 a 0],
  %w[2 中京 4 5 nil 1000 d 0 a 0],
  %w[2 中京 4 5 マカオJCT 1700 t 0 a 0],
  %w[2 中京 5u 5 nil 1700 d 0 a 0],
  %w[2 中京 5u 9 nil 1000 d 0 a 0],
  %w[2 中京 5u 9 インディアT 2000 t 0 h 0],
  %w[2 中京 5u 16 マラヤンRAT 1800 t 0 a 0],
  %w[2 中京 4u g2 金鯱賞 2000 t 0 s 0],
  %w[3 東京 4 m nil 1600 d d a 0],
  %w[3 東京 4 m nil 2400 t 0 a 0],
  %w[3 東京 4 5 nil 1400 d 0 a 0],
  %w[3 東京 4 9 駒草賞 2000 t 0 a 0],
  %w[3 東京 4 g1 日本ダービー 2400 t 0 c 0],
  %w[3 東京 5u 5 nil 2000 t 0 a 0],
  %w[3 東京 5u 9 是政特別 1800 t 0 h 0],
  %w[3 東京 5u 16 むらさき賞 1600 t 0 h 0],
  %w[3 東京 5u g3 エプソムC 1800 t 0 s 0],
  %w[3 中京 4 m nil 1700 d d a 0],
  %w[3 中京 4 m nil 1200 t 0 a 0],
  %w[3 中京 4 5 nil 1700 d f a 0],
  %w[3 中京 4 5 こでまり賞 1200 t 0 a 0],
  %w[3 中京 4 o 白百合S 1800 t 0 s 0],
  %w[3 中京 5u 5 nil 1200 t 0 a 0],
  %w[3 中京 5u 9 木曽川特別 2500 t 0 a 0],
  %w[3 中京 5u 16 飛騨S 1200 t 0 h 0],
  %w[3 中京 4u o テレビ愛知OP 1800 t 0 s 0],
  %w[4 東京 4 m nil 1200 d 0 a 0],
  %w[4 東京 4 m nil 1600 t 0 a 0],
  %w[4 東京 4 5 nil 1400 d f a 0],
  %w[4 東京 4 5 ほうせんか賞 2000 t 0 a 0],
  %w[4 東京 4 o 菖蒲S 1600 t 0 s 0],
  %w[4 東京 5u 5 nil 1400 d 0 a 0],
  %w[4 東京 5u 9 日吉特別 1600 d 0 h 0],
  %w[4 東京 5u g2 目黒記念 2500 t 0 h 0],
  %w[4 東京 5u g1 安田記念 1600 t 0 c 0],
  %w[4 中京 4 m nil 1000 d 0 a 0],
  %w[4 中京 4 m nil 1800 t 0 a 0],
  %w[4 中京 4 5 nil 2000 t 0 a 0],
  %w[4 中京 4 5 すいれん賞 2500 t 0 a 0],
  %w[4 中京 4 g3 中日スポーツ賞４歳S 1200 t 0 s 0],
  %w[4 中京 5u 5 nil 2000 t 0 a 0],
  %w[4 中京 5u 9 三河特別 1700 d 0 a 0],
  %w[4 中京 5u 16 関ヶ原S 2000 t 0 h 0],
  %w[4 中京 4u o 東海S 1700 d 0 h 0],
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
