month = 2

Race.where(month: month).destroy_all

[
  %w[1 東京 4 m nil 1200 d d a 0],
  %w[1 東京 4 m nil 1600 t 0 a 0],
  %w[1 東京 4 5 カトレア賞 1600 d 0 a 0],
  %w[1 東京 4 g3 クイーンC 1600 t f s 0],
  %w[1 東京 5u 5 nil 1600 d 0 a 0],
  %w[1 東京 5u 9 nil 1400 d f a 0],
  %w[1 東京 5u 9 大島特別 2100 d 0 a 0],
  %w[1 東京 5u 16 白嶺S 1600 t 0 a 0],
  %w[1 東京 5u o 銀嶺S 1400 d 0 s 0],
  %w[1 京都 4 m nil 1200 d 0 a 0],
  %w[1 京都 4 m nil 1800 t 0 a 0],
  %w[1 京都 4 5 こぶし賞 1600 t 0 a 0],
  %w[1 京都 4 o バイオレットS 1400 d 0 s 0],
  %w[1 京都 5u 5 nil 1800 d 0 a 0],
  %w[1 京都 5u 9 nil 1800 d 0 a 0],
  %w[1 京都 5u 9 琵琶湖特別 2400 t 0 h 0],
  %w[1 京都 5u 16 北山S 1800 d 0 a 0],
  %w[1 京都 5u g3 京都牝馬特別 1600 t f s 0],
  %w[1 小倉 4 m nil 1200 t 0 a 0],
  %w[1 小倉 4 m nil 1700 d 0 a 0],
  %w[1 小倉 4 5 あすなろ賞 2000 t 0 a 0],
  %w[1 小倉 5u 5 nil 1700 d 0 a 0],
  %w[1 小倉 5u 5 nil 2600 t 0 a 0],
  %w[1 小倉 5u 5 巌流島特別 1200 t 0 a 0],
  %w[1 小倉 5u 9 太宰府特別 1800 t 0 h 0],
  %w[1 小倉 5u o 関門橋S 2000 t 0 s 0],
  %w[2 東京 4 m nil 1200 d 0 a 0],
  %w[2 東京 4 m nil 1600 d 0 a 0],
  %w[2 東京 4 5 セントポーリア賞 1800 t 0 a 0],
  %w[2 東京 4 o ヒヤシンスS 1600 d 0 s 0],
  %w[2 東京 5u 5 nil 1200 d 0 a 0],
  %w[2 東京 5u 9 nil 1600 d 0 a 0],
  %w[2 東京 5u 9 節分賞 1400 d 0 a 0],
  %w[2 東京 5u 16 金蹄S 2100 d 0 a 0],
  %w[2 東京 5u g3 東京新聞杯 1600 t 0 s 0],
  %w[2 京都 4 m nil 1200 d f a 0],
  %w[2 京都 4 m nil 1800 d 0 a 0],
  %w[2 京都 4 5 寒桜賞 1200 d 0 a 0],
  %w[2 京都 4 g3 きさらぎ賞 1800 t 0 s 0],
  %w[2 京都 5u 5 nil 1200 d 0 a 0],
  %w[2 京都 5u 9 nil 1800 d f a 0],
  %w[2 京都 5u 9 宇治川特別 1400 t 0 a 0],
  %w[2 京都 5u 16 松籟S 2400 t 0 a 0],
  %w[2 京都 5u o すばるS 1400 d 0 h 0],
  %w[2 小倉 4 m nil 1000 d 0 a 0],
  %w[2 小倉 4 m nil 1200 t f a 0],
  %w[2 小倉 4 m nil 1800 t 0 a 0],
  %w[2 小倉 4 5 かささぎ賞 1800 t 0 a 0],
  %w[2 小倉 5u 5 nil 1000 d 0 a 0],
  %w[2 小倉 5u 5 nil 1800 t 0 a 0],
  %w[2 小倉 5u 5 筑前特別 1700 d 0 a 0],
  %w[2 小倉 5u 9 早鞆特別 1700 d 0 h 0],
  %w[3 東京 4 m nil 1400 d 0 a 0],
  %w[3 東京 4 m nil 1600 d f a 0],
  %w[3 東京 4 5 nil 1200 d 0 a 0],
  %w[3 東京 4 g3 共同通信杯 1800 t 0 s 0],
  %w[3 東京 5u 5 nil 2100 d 0 a 0],
  %w[3 東京 5u 9 nil 1200 d 0 a 0],
  %w[3 東京 5u 9 立春賞 2400 t 0 h 0],
  %w[3 東京 5u 16 テレビ山梨杯 2000 t 0 a 0],
  %w[3 東京 5u o バレンタインS 1800 t 0 a 0],
  %w[3 京都 4 m nil 1400 d d a 0],
  %w[3 京都 4 m nil 2200 t 0 a 0],
  %w[3 京都 4 5 つばき賞 2000 t 0 a 0],
  %w[3 京都 4 5 飛梅賞 1800 d 0 a 0],
  %w[3 京都 5u 5 nil 1800 d 0 a 0],
  %w[3 京都 5u 9 nil 1400 d 0 a 0],
  %w[3 京都 5u 9 大津特別 2000 t 0 h 0],
  %w[3 京都 5u 16 斑鳩S 1600 t 0 h 0],
  %w[3 京都 5u g2 京都記念 2200 t 0 s 0],
  %w[3 小倉 4 m nil 1000 t 0 a 0],
  %w[3 小倉 4 m nil 1700 d f a 0],
  %w[3 小倉 4 m nil 2000 t 0 a 0],
  %w[3 小倉 4 5 萌黄賞 1200 t 0 a 0],
  %w[3 小倉 5u 5 nil 1000 d 0 a 0],
  %w[3 小倉 5u 5 nil 1700 d d a 0],
  %w[3 小倉 5u 5 秋吉台特別 1800 t 0 a 0],
  %w[3 小倉 5u 9 火の山特別 1200 t 0 h 0],
  %w[4 東京 4 m nil 1200 t 0 a 0],
  %w[4 東京 4 m nil 1800 t 0 a 0],
  %w[4 東京 4 5 春菜賞 1400 t 0 a 0],
  %w[4 東京 5u 5 nil 1400 d 0 a 0],
  %w[4 東京 5u 9 nil 2100 d 0 a 0],
  %w[4 東京 5u 9 テレビ埼玉杯 1600 t 0 a 0],
  %w[4 東京 5u 16 アメジストS 1400 t 0 h 0],
  %w[4 東京 5u g3 ダイヤモンドS 3200 t 0 h 0],
  %w[4 東京 5u g1 フェブラリーS 1600 d 0 c 0],
  %w[4 京都 4 m nil 1800 d 0 a 0],
  %w[4 京都 4 m nil 1400 t 0 a 0],
  %w[4 京都 4 5 梅花賞 1800 t 0 a 0],
  %w[4 京都 4 o エルフィンS 1600 t f s 0],
  %w[4 京都 5u 5 nil 1400 d 0 a 0],
  %w[4 京都 5u 9 nil 1200 d 0 a 0],
  %w[4 京都 5u 9 木津川特別 1600 t 0 a 0],
  %w[4 京都 5u 16 橿原S 1400 d 0 a 0],
  %w[4 京都 5u o 淀短距離S 1200 t 0 h 0],
  %w[4 小倉 4 m nil 1200 t 0 a 0],
  %w[4 小倉 4 m nil 2000 t 0 a 0],
  %w[4 小倉 4 5 くすのき賞 2000 t 0 a 0],
  %w[4 小倉 5u 5 nil 1000 t 0 a 0],
  %w[4 小倉 5u 5 nil 1700 d f a 0],
  %w[4 小倉 5u 5 紫川特別 2000 t 0 a 0],
  %w[4 小倉 5u 9 皿倉山特別 2600 t 0 a 0],
  %w[4 小倉 5u g3 小倉大賞典 1800 t 0 h 0],
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
