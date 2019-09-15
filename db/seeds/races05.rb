month = 5

Race.where(month: month).destroy_all

[
  %w[1 東京 4 m nil 1400 d f a 0],
  %w[1 東京 4 m nil 2400 t 0 a 0],
  %w[1 東京 4 5 新緑賞 2200 t 0 a 0],
  %w[1 東京 4 g2 NZT４歳S 1400 t 0 c 0],
  %w[1 東京 5u 5 nil 1600 t 0 a 0],
  %w[1 東京 5u 9 nil 1400 d 0 a 0],
  %w[1 東京 5u 9 高尾特別 1400 t 0 h 0],
  %w[1 東京 5u 16 丹沢S 2100 d 0 a 0],
  %w[1 東京 5u o オアシスS 1600 d 0 h 0],
  %w[1 京都 4 m nil 1400 d f a 0],
  %w[1 京都 4 m nil 2400 t 0 a 0],
  %w[1 京都 4 5 ムーニーバレーRC賞 1800 t 0 a 0],
  %w[1 京都 4 o マーガレットS 1600 t 0 s 0],
  %w[1 京都 5u 5 nil 2000 t 0 a 0],
  %w[1 京都 5u 9 nil 1200 t 0 a 0],
  %w[1 京都 5u 9 シドニーT 1200 t 0 h 0],
  %w[1 京都 5u 16 メルボルンT 1400 d 0 a 0],
  %w[1 京都 5u g3 シルクロードS 1200 t 0 s 0],
  %w[1 新潟 4 m nil 1200 t 0 a 0],
  %w[1 新潟 4 m nil 1600 t 0 a 0],
  %w[1 新潟 4 5 わらび賞 1600 t 0 a 0],
  %w[1 新潟 5u 5 nil 1700 d 0 a 0],
  %w[1 新潟 5u 5 nil 1400 t f a 0],
  %w[1 新潟 5u 5 荒川峡特別 2200 t 0 a 0],
  %w[1 新潟 5u 9 白馬岳特別 1700 d 0 a 0],
  %w[1 新潟 5u o 谷川岳S 1600 t 0 s 0],
  %w[2 東京 4 m nil 1400 d 0 a 0],
  %w[2 東京 4 m nil 1800 t 0 a 0],
  %w[2 東京 4 5 若鮎賞 1400 t 0 a 0],
  %w[2 東京 4 g2 オークストライアル 2000 t 0 c 0],
  %w[2 東京 5u 5 nil 1200 d 0 a 0],
  %w[2 東京 5u 9 nil 2000 d 0 a 0],
  %w[2 東京 5u 9 清里特別 1600 d 0 h 0],
  %w[2 東京 5u 16 府中S 1600 t 0 a 0],
  %w[2 東京 5u o メトロポリタンS 2300 t 0 s 0],
  %w[2 京都 4 m nil 1800 d d a 0],
  %w[2 京都 4 m nil 1200 t 0 a 0],
  %w[2 京都 4 5 nil 1800 d 0 a 0],
  %w[2 京都 4 5 矢車賞 1600 t f a 0],
  %w[2 京都 5u 5 nil 1600 t 0 a 0],
  %w[2 京都 5u 9 nil 1800 d 0 a 0],
  %w[2 京都 5u 9 祇園特別 1800 d 0 h 0],
  %w[2 京都 5u 16 上加茂S 1400 t 0 a 0],
  %w[2 京都 5u g1 天皇賞(春) 3200 t 0 c 0],
  %w[2 新潟 4 m nil 1400 t 0 a 0],
  %w[2 新潟 4 m nil 1600 t f a 0],
  %w[2 新潟 4 m nil 2200 t 0 a 0],
  %w[2 新潟 4 5 こけもも賞 2200 t 0 a 0],
  %w[2 新潟 5u 5 nil 1200 d 0 a 0],
  %w[2 新潟 5u 5 nil 2000 t 0 a 0],
  %w[2 新潟 5u 5 二王子岳特別 1600 t 0 a 0],
  %w[2 新潟 5u 9 大日岳特別 1200 t 0 h 0],
  %w[3 東京 4 m nil 1600 d d a 0],
  %w[3 東京 4 m nil 2000 t 0 a 0],
  %w[3 東京 4 5 八重桜賞 1600 t 0 a 0],
  %w[3 東京 4 o スイートピーS 1800 t f c 0],
  %w[3 東京 4 g3 青葉賞 2400 t 0 c 0],
  %w[3 東京 5u 5 nil 2000 t 0 a 0],
  %w[3 東京 5u 9 nil 1200 d 0 a 0],
  %w[3 東京 5u 9 陣馬特別 2400 t 0 a 0],
  %w[3 東京 5u 16 薫風S 1800 t 0 a 0],
  %w[3 京都 4 m nil 1200 d 0 a 0],
  %w[3 京都 4 m nil 2000 t 0 a 0],
  %w[3 京都 4 5 あやめ賞 1400 t 0 a 0],
  %w[3 京都 4 g3 京都４歳特別 2000 t 0 s 0],
  %w[3 京都 5u 5 nil 2400 t 0 a 0],
  %w[3 京都 5u 9 nil 1200 d 0 a 0],
  %w[3 京都 5u 9 高瀬川特別 1400 t 0 a 0],
  %w[3 京都 5u 16 下鴨S 2000 t 0 h 0],
  %w[3 京都 5u g3 アンタレスS 1800 d 0 h 0],
  %w[3 新潟 4 m nil 1200 d 0 a 0],
  %w[3 新潟 4 m nil 1600 t 0 a 0],
  %w[3 新潟 4 m nil 2000 t f a 0],
  %w[3 新潟 4 5 ひめさゆり賞 1200 t 0 a 0],
  %w[3 新潟 5u 5 nil 1000 d 0 a 0],
  %w[3 新潟 5u 5 nil 1600 t 0 a 0],
  %w[3 新潟 5u 5 六日町特別 1200 d 0 a 0],
  %w[3 新潟 5u 9 金北山特別 2000 t 0 a 0],
  %w[4 東京 4 m nil 1200 d 0 a 0],
  %w[4 東京 4 m nil 1600 t 0 a 0],
  %w[4 東京 4 5 夏木立賞 1800 t 0 a 0],
  %w[4 東京 4 o プリンシパルS 2200 t 0 c 0],
  %w[4 東京 4 g1 NHKマイルC 1600 t 0 c 0],
  %w[4 東京 5u 5 nil 1400 d 0 a 0],
  %w[4 東京 5u 9 nil 1400 t f a 0],
  %w[4 東京 5u 9 秩父特別 1800 t 0 h 0],
  %w[4 東京 5u g2 京王杯SC 1400 t 0 s 0],
  %w[4 京都 4 m nil 1800 d 0 a 0],
  %w[4 京都 4 m nil 1600 t 0 a 0],
  %w[4 京都 4 5 たちばな賞 2400 t 0 a 0],
  %w[4 京都 4 o 葵S 1200 t 0 s 0],
  %w[4 京都 5u 5 nil 1400 d 0 a 0],
  %w[4 京都 5u 9 nil 1800 d 0 a 0],
  %w[4 京都 5u 9 白川特別 2400 t 0 h 0],
  %w[4 京都 5u 16 朱雀S 1600 t 0 h 0],
  %w[4 京都 5u o 栗東S 1200 d 0 s 0],
  %w[4 新潟 4 m nil 1400 t 0 a 0],
  %w[4 新潟 4 m nil 2000 t 0 a 0],
  %w[4 新潟 4 5 ゆきつばき賞 2000 t 0 a 0],
  %w[4 新潟 5u 5 nil 2200 t 0 a 0],
  %w[4 新潟 5u 5 nil 1200 t 0 a 0],
  %w[4 新潟 5u 5 三条特別 1700 d 0 a 0],
  %w[4 新潟 5u 9 朝日岳特別 1600 t 0 h 0],
  %w[4 新潟 5u g3 新潟大賞典 2000 t 0 h 0],
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
