month = 3

Race.where(month: month).destroy_all

[
  %w[1 中山 4 m nil 1800 d 0 a 0],
  %w[1 中山 4 m nil 1600 t 0 a 0],
  %w[1 中山 4 5 きんせんか賞 1200 t 0 a 0],
  %w[1 中山 4 o クロッカスS 1600 t 0 s 0],
  %w[1 中山 5u 5 nil 1200 d 0 a 0],
  %w[1 中山 5u 9 nil 1200 t 0 a 0],
  %w[1 中山 5u 9 潮来特別 2500 t 0 a 0],
  %w[1 中山 5u 16 内外タイムス杯 1800 t 0 h 0],
  %w[1 中山 5u g3 中山牝馬S 1800 t f h 0],
  %w[1 阪神 4 m nil 1200 d d a 0],
  %w[1 阪神 4 m nil 1600 t 0 a 0],
  %w[1 阪神 4 5 雪割草特別 1200 t 0 a 0],
  %w[1 阪神 4 g3 アーリントンC 1600 t 0 s 0],
  %w[1 阪神 5u 5 nil 1800 d 0 a 0],
  %w[1 阪神 5u 9 nil 1800 d 0 a 0],
  %w[1 阪神 5u 9 須磨特別 1200 t 0 a 0],
  %w[1 阪神 5u 16 甲南S 2500 t 0 h 0],
  %w[1 阪神 5u o 仁川S 1800 d 0 h 0],
  %w[1 中京 4 m nil 1000 d 0 a 0],
  %w[1 中京 4 m nil 1700 d f a 0],
  %w[1 中京 4 m nil 1800 t 0 a 0],
  %w[1 中京 4 5 ふきのとう特別 1800 t 0 a 0],
  %w[1 中京 5u 5 nil 1000 d 0 a 0],
  %w[1 中京 5u 5 nil 1700 d 0 a 0],
  %w[1 中京 5u 5 下呂特別 2000 t 0 a 0],
  %w[1 中京 5u 9 瀬戸特別 1700 d 0 h 0],
  %w[2 中山 4 m nil 1200 d d a 0],
  %w[2 中山 4 m nil 2000 t 0 a 0],
  %w[2 中山 4 5 桃花賞 1600 t f a 0],
  %w[2 中山 4 g2 弥生賞 2000 t 0 s 0],
  %w[2 中山 5u 5 nil 1800 d 0 a 0],
  %w[2 中山 5u 9 nil 1200 d 0 a 0],
  %w[2 中山 5u 9 館山特別 1800 t 0 h 0],
  %w[2 中山 5u 16 京葉S 1800 t 0 a 0],
  %w[2 中山 5u o オーシャンS 1200 t 0 h 0],
  %w[2 阪神 4 m nil 1200 d f a 0],
  %w[2 阪神 4 m nil 1800 d 0 a 0],
  %w[2 阪神 4 5 ゆきやなぎ賞 2000 t 0 a 0],
  %w[2 阪神 4 g3 チューリップS 1600 t f c 0],
  %w[2 阪神 5u 5 nil 1200 d 0 a 0],
  %w[2 阪神 5u 9 nil 1400 d f a 0],
  %w[2 阪神 5u 9 淡路特別 2500 t 0 a 0],
  %w[2 阪神 5u 16 但馬S 2000 t 0 a 0],
  %w[2 阪神 5u g2 マイラーズC 1600 t 0 s 0],
  %w[2 中京 4 m nil 1000 d 0 a 0],
  %w[2 中京 4 m nil 2000 t 0 a 0],
  %w[2 中京 4 5 沈丁花賞 1700 d 0 a 0],
  %w[2 中京 5u 5 nil 1000 d 0 a 0],
  %w[2 中京 5u 5 nil 1800 t 0 a 0],
  %w[2 中京 5u 5 鳳来寺山特別 1700 d 0 a 0],
  %w[2 中京 5u 9 鈴鹿特別 1200 t 0 a 0],
  %w[2 中京 5u g3 中日新聞杯 1800 t d s 0],
  %w[3 中山 4 m nil 1200 d f a 0],
  %w[3 中山 4 m nil 1800 d 0 a 0],
  %w[3 中山 4 5 水仙賞 2000 t 0 a 0],
  %w[3 中山 5u 5 nil 1200 d 0 a 0],
  %w[3 中山 5u 9 nil 1800 d 0 a 0],
  %w[3 中山 5u 9 常陸特別 1200 d 0 a 0],
  %w[3 中山 5u 16 サンシャインS 2500 t 0 h 0],
  %w[3 中山 5u g3 マーチS 1800 d 0 h 0],
  %w[3 中山 5u g2 中山記念 1800 t 0 s 0],
  %w[3 阪神 4 m nil 1400 d 0 a 0],
  %w[3 阪神 4 m nil 2000 t 0 a 0],
  %w[3 阪神 4 o すみれS 2200 t 0 s 0],
  %w[3 阪神 4 g2 ４歳牝馬特別 1400 t f c 0],
  %w[3 阪神 5u 5 nil 1400 d 0 a 0],
  %w[3 阪神 5u 9 nil 1600 t 0 a 0],
  %w[3 阪神 5u 9 洲本特別 1800 d 0 a 0],
  %w[3 阪神 5u 16 武庫川S 1200 t 0 a 0],
  %w[3 阪神 5u o コーラルS 1400 d 0 s 0],
  %w[3 中京 4 m nil 1000 d f a 0],
  %w[3 中京 4 m nil 1700 d 0 a 0],
  %w[3 中京 4 m nil 1200 t 0 a 0],
  %w[3 中京 4 5 はなのき賞 1200 t 0 a 0],
  %w[3 中京 5u 5 nil 1000 d d a 0],
  %w[3 中京 5u 5 nil 2300 d 0 a 0],
  %w[3 中京 5u 5 御嶽特別 1200 t 0 a 0],
  %w[3 中京 5u 9 恋路ヶ浜特別 2500 t 0 a 0],
  %w[4 中山 4 m nil 1200 d 0 a 0],
  %w[4 中山 4 m nil 2200 t 0 a 0],
  %w[4 中山 4 5 nil 1800 d 0 a 0],
  %w[4 中山 4 g3 フラワーC 1800 t f a 0],
  %w[4 中山 4 g2 スプリングS 1800 t 0 c 0],
  %w[4 中山 5u 5 nil 1800 d f a 0],
  %w[4 中山 5u 9 nil 1200 d 0 a 0],
  %w[4 中山 5u 9 両国特別 1200 t 0 h 0],
  %w[4 中山 5u 16 千葉S 1200 t 0 h 0],
  %w[4 阪神 4 m nil 1200 d 0 a 0],
  %w[4 阪神 4 m nil 1800 d 0 a 0],
  %w[4 阪神 4 5 さわらび賞 1600 t 0 a 0],
  %w[4 阪神 4 o アネモネS 1400 t f c 0],
  %w[4 阪神 5u 5 nil 1800 d 0 a 0],
  %w[4 阪神 5u 9 nil 1400 d 0 a 0],
  %w[4 阪神 5u 9 千里山特別 2000 t 0 h 0],
  %w[4 阪神 5u 16 鳴門S 1800 d 0 a 0],
  %w[4 阪神 5u g2 阪神大賞典 3000 t 0 s 0],
  %w[4 中京 4 m nil 1000 d 0 a 0],
  %w[4 中京 4 m nil 1700 d 0 a 0],
  %w[4 中京 4 5 フリージア賞 2000 t 0 a 0],
  %w[4 中京 5u 5 nil 1000 d 0 a 0],
  %w[4 中京 5u 5 nil 1700 d f a 0],
  %w[4 中京 5u 5 渥美特別 2500 t 0 a 0],
  %w[4 中京 5u 9 長良川特別 1800 t 0 a 0],
  %w[4 中京 5u g3 中京記念 2000 t 0 h 0],
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
