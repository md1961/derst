month = 7

Race.where(month: month).destroy_all

[
  %w[1 福島 4 m nil 1000 d 0 a 0],
  %w[1 福島 4 m nil 1800 t 0 a 0],
  %w[1 福島 4 5 nil 1700 d 0 a 0],
  %w[1 福島 4 5 クレマチス賞 1200 t 0 a 0],
  %w[1 福島 5u 5 nil 1200 t 0 a 0],
  %w[1 福島 5u 5 nil 2600 t 0 a 0],
  %w[1 福島 5u 9 尾瀬特別 1200 t 0 h 0],
  %w[1 福島 5u 16 福島テレビ杯 2000 t 0 h 0],
  %w[1 福島 4u o バーデンバーデンC 1200 t 0 s 0],
  %w[1 阪神 4 m nil 1400 d 0 a 0],
  %w[1 阪神 4 m nil 2500 t 0 a 0],
  %w[1 阪神 4 5 nil 1400 d f a 0],
  %w[1 阪神 4 5 胡蝶蘭賞 2000 t 0 a 0],
  %w[1 阪神 4 9 白丁花S 1600 t 0 a 0],
  %w[1 阪神 5u 5 nil 1200 d 0 a 0],
  %w[1 阪神 5u 9 舞子特別 2200 t 0 a 0],
  %w[1 阪神 5u 16 安芸S 1400 d 0 h 0],
  %w[1 阪神 4u g2 鳴尾記念 2000 t 0 s 0],
  %w[1 函館 3 n nil 1000 t 0 a 0],
  %w[1 函館 4u m nil 1000 d 0 a 0],
  %w[1 函館 4u m nil 1800 t 0 a 0],
  %w[1 函館 4u 5 nil 1000 d 0 a 0],
  %w[1 函館 4u 5 奥尻特別 1800 t 0 a 0],
  %w[1 函館 4u 9 五稜郭特別 2000 t 0 a 0],
  %w[1 函館 4u 16 大沼S 1700 d 0 a 0],
  %w[1 函館 4u o 巴賞 1800 t 0 s 0],
  %w[2 福島 4 m nil 1200 t d a 0],
  %w[2 福島 4 m nil 1700 d 0 a 0],
  %w[2 福島 4 5 nil 1700 d f a 0],
  %w[2 福島 4 5 アマリリス賞 2000 t 0 a 0],
  %w[2 福島 4 9 しゃくなげS 2000 t 0 a 0],
  %w[2 福島 5u 5 nil 1200 t f a 0],
  %w[2 福島 5u 5 nil 2000 t 0 a 0],
  %w[2 福島 5u 9 猪苗代特別 1700 d 0 a 0],
  %w[2 福島 5u 16 阿武隈S 1700 d 0 h 0],
  %w[2 阪神 4 m nil 1400 d f a 0],
  %w[2 阪神 4 m nil 2000 t 0 a 0],
  %w[2 阪神 4 5 nil 1200 d 0 a 0],
  %w[2 阪神 4 5 あじさい賞 1600 t 0 a 0],
  %w[2 阪神 4 9 ゆうすげS 1200 t 0 a 0],
  %w[2 阪神 5u 5 nil 1400 t 0 a 0],
  %w[2 阪神 5u 9 小野特別 1200 t 0 a 0],
  %w[2 阪神 5u 16 グリーンS 2500 t 0 a 0],
  %w[2 阪神 4u g3 マーメイドS 2000 t f s 0],
  %w[2 函館 3 n nil 1000 d 0 a 0],
  %w[2 函館 3 n nil 1000 t f a 0],
  %w[2 函館 4u m nil 1700 d d a 0],
  %w[2 函館 4u m nil 1200 t 0 a 0],
  %w[2 函館 4u 5 nil 1000 t 0 a 0],
  %w[2 函館 4u 5 十和田湖特別 1700 d 0 a 0],
  %w[2 函館 4u 9 潮騒特別 1200 t 0 h 0],
  %w[2 函館 4u o マリーンS 1700 d 0 s 0],
  %w[3 福島 4 m nil 1700 d f a 0],
  %w[3 福島 4 m nil 2000 t 0 a 0],
  %w[3 福島 4 5 nil 1800 t 0 a 0],
  %w[3 福島 4 5 アベリア賞 1700 d 0 a 0],
  %w[3 福島 4 g3 ラジオたんぱ賞 1800 t 0 s 0],
  %w[3 福島 5u 5 nil 1700 d 0 a 0],
  %w[3 福島 5u 5 nil 1800 t 0 a 0],
  %w[3 福島 5u 9 信夫山特別 2600 t 0 a 0],
  %w[3 福島 5u 16 TUF杯 1800 t 0 a 0],
  %w[3 阪神 4 m nil 1800 d d a 0],
  %w[3 阪神 4 m nil 1200 t 0 a 0],
  %w[3 阪神 4 5 nil 1800 d 0 a 0],
  %w[3 阪神 4 5 マロニエ賞 1200 t 0 a 0],
  %w[3 阪神 4 9 やまゆりS 2000 t 0 h 0],
  %w[3 阪神 5u 5 nil 1200 t 0 a 0],
  %w[3 阪神 5u 9 生田特別 2500 t 0 h 0],
  %w[3 阪神 5u 16 ストークS 1600 t 0 a 0],
  %w[3 阪神 4u o 灘S 1800 d 0 s 0],
  %w[3 函館 3 n nil 1200 t 0 a 0],
  %w[3 函館 4u m nil 1000 d 0 a 0],
  %w[3 函館 4u m nil 2000 t 0 a 0],
  %w[3 函館 4u 5 nil 1700 d 0 a 0],
  %w[3 函館 4u 5 八甲田山特別 2600 t 0 a 0],
  %w[3 函館 4u 9 竜飛崎特別 1700 d 0 h 0],
  %w[3 函館 4u 16 漁火S 1800 t 0 a 0],
  %w[3 函館 4u g3 函館記念 2000 t 0 h 0],
  %w[4 福島 4 m nil 1000 t 0 a 0],
  %w[4 福島 4 m nil 1700 d 0 a 0],
  %w[4 福島 4 5 nil 1000 d 0 a 0],
  %w[4 福島 4 5 べにはな賞 1800 t f a 0],
  %w[4 福島 4 9 さくらんぼS 1700 t 0 h 0],
  %w[4 福島 5u 5 nil 1000 d 0 a 0],
  %w[4 福島 5u 5 nil 1800 t f a 0],
  %w[4 福島 5u 9 織姫賞 2000 t 0 a 0],
  %w[4 福島 4u g3 七夕賞 2000 t 0 h 0],
  %w[4 阪神 4 m nil 1400 d 0 a 0],
  %w[4 阪神 4 m nil 2000 t 0 a 0],
  %w[4 阪神 4 5 nil 1200 d 0 a 0],
  %w[4 阪神 4 5 かきつばた賞 2500 t 0 a 0],
  %w[4 阪神 4 o 菩提樹S 1400 t 0 s 0],
  %w[4 阪神 5u 5 nil 1800 d 0 a 0],
  %w[4 阪神 5u 9 鷹取特別 1200 d 0 a 0],
  %w[4 阪神 5u 16 垂水S 2000 t 0 a 0],
  %w[4 阪神 4u g1 宝塚記念 2200 t 0 c 0],
  %w[4 函館 3 n nil 1000 t 0 a 0],
  %w[4 函館 3 g3 函館３歳S 1200 t 0 a 0],
  %w[4 函館 4u m nil 1000 d f a 0],
  %w[4 函館 4u m nil 1700 d 0 a 0],
  %w[4 函館 4u 5 nil 2000 t 0 a 0],
  %w[4 函館 4u 5 登別特別 1200 t f a 0],
  %w[4 函館 4u 9 みなみ北海道S 2600 t 0 h 0],
  %w[4 函館 4u g3 函館スプリントS 1200 t 0 s 0],
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
