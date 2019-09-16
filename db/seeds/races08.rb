month = 8

Race.where(month: month).destroy_all

[
  %w[1 新潟 3 n nil 1000 d 0 a 0],
  %w[1 新潟 4u m nil 1200 d 0 a 0],
  %w[1 新潟 4u m nil 1800 t 0 a 0],
  %w[1 新潟 4u 5 nil 1000 t f a 0],
  %w[1 新潟 4u 5 石打特別 1600 t 0 a 0],
  %w[1 新潟 4u 5 寺泊特別 2200 t 0 a 0],
  %w[1 新潟 4u 9 麒麟山特別 1700 t 0 a 0],
  %w[1 新潟 4u 16 天の川S 1800 t 0 h 0],
  %w[1 新潟 4u g3 関屋記念 1600 t 0 s 0],
  %w[1 小倉 3 n nil 1200 t 0 a 0],
  %w[1 小倉 4u m nil 1000 d 0 a 0],
  %w[1 小倉 4u m nil 2000 t 0 a 0],
  %w[1 小倉 4u m nil 1200 t 0 a 0],
  %w[1 小倉 4u 5 nil 1000 d 0 a 0],
  %w[1 小倉 4u 5 洞海特別 1200 t 0 a 0],
  %w[1 小倉 4u 5 由布院特別 1700 t 0 a 0],
  %w[1 小倉 4u 9 雲仙特別 1200 t 0 a 0],
  %w[1 小倉 4u g3 北九州記念 1800 t 0 h 0],
  %w[1 札幌 3 n nil 1000 t 0 a 0],
  %w[1 札幌 3 n nil 1200 t f a 0],
  %w[1 札幌 4u m nil 1000 d 0 a 0],
  %w[1 札幌 4u m nil 1700 d 0 a 0],
  %w[1 札幌 4u 5 nil 1700 d 0 a 0],
  %w[1 札幌 4u 5 富良野特別 2600 t 0 a 0],
  %w[1 札幌 4u 9 摩周湖特別 1500 t 0 a 0],
  %w[1 札幌 4u o 札幌日経OP 1800 t 0 s 0],
  %w[2 新潟 3 n nil 1000 d 0 a 0],
  %w[2 新潟 4u m nil 1000 t 0 a 0],
  %w[2 新潟 4u m nil 1600 t 0 a 0],
  %w[2 新潟 4u m nil 2200 t 0 a 0],
  %w[2 新潟 4u 5 nil 2000 t 0 a 0],
  %w[2 新潟 4u 5 柏崎特別 1700 d 0 a 0],
  %w[2 新潟 4u 5 白山特別 1400 t 0 a 0],
  %w[2 新潟 4u 9 苗場特別 1200 t 0 h 0],
  %w[2 新潟 4u o 関越S 1700 d 0 s 0],
  %w[2 小倉 3 n nil 1000 d 0 a 0],
  %w[2 小倉 4u m nil 1000 t 0 a 0],
  %w[2 小倉 4u m nil 1700 d d a 0],
  %w[2 小倉 4u 5 nil 1200 t 0 a 0],
  %w[2 小倉 4u 5 指宿特別 1700 d 0 a 0],
  %w[2 小倉 4u 5 都井岬特別 1800 t 0 a 0],
  %w[2 小倉 4u 9 玄海特別 2000 t 0 a 0],
  %w[2 小倉 4u 16 阿蘇S 1700 d 0 a 0],
  %w[2 小倉 4u o 北九州短距離S 1200 t 0 h 0],
  %w[2 札幌 3 n nil 1000 d 0 a 0],
  %w[2 札幌 3 m nil 1800 t 0 a 0],
  %w[2 札幌 4u m nil 1700 d d a 0],
  %w[2 札幌 4u m nil 1200 t 0 a 0],
  %w[2 札幌 4u 5 nil 1500 t 0 a 0],
  %w[2 札幌 4u 5 知床特別 2000 t 0 a 0],
  %w[2 札幌 4u 9 支笏湖特別 2000 t 0 a 0],
  %w[2 札幌 4u 16 大雪ハンデ 1700 d 0 h 0],
  %w[3 新潟 3 n nil 1700 t 0 a 0],
  %w[3 新潟 4u m nil 1700 d 0 a 0],
  %w[3 新潟 4u m nil 1800 t d a 0],
  %w[3 新潟 4u m nil 2000 t 0 a 0],
  %w[3 新潟 4u 5 nil 1000 d 0 a 0],
  %w[3 新潟 4u 5 村上特別 1200 t 0 a 0],
  %w[3 新潟 4u 5 妙高特別 1800 t 0 a 0],
  %w[3 新潟 4u 9 三面川特別 2200 t 0 a 0],
  %w[3 新潟 4u g3 新潟記念 2000 t 0 h 0],
  %w[3 小倉 3 n nil 1000 t 0 a 0],
  %w[3 小倉 4u m nil 1000 d f a 0],
  %w[3 小倉 4u m nil 1200 t 0 a 0],
  %w[3 小倉 4u m nil 1700 d 0 a 0],
  %w[3 小倉 4u 5 nil 1800 t 0 a 0],
  %w[3 小倉 4u 5 伊万里特別 1200 t f a 0],
  %w[3 小倉 4u 5 高千穂特別 2000 t 0 a 0],
  %w[3 小倉 4u 9 桜島特別 1700 d 0 h 0],
  %w[3 小倉 4u g3 小倉記念 2000 t 0 s 0],
  %w[3 札幌 3 n nil 1200 t 0 a 0],
  %w[3 札幌 3 m nil 1000 d 0 a 0],
  %w[3 札幌 4u m nil 1000 d f a 0],
  %w[3 札幌 4u m nil 1700 d 0 a 0],
  %w[3 札幌 4u 5 nil 1800 t 0 a 0],
  %w[3 札幌 4u 5 小樽特別 1200 t 0 a 0],
  %w[3 札幌 4u 9 オホーツクH 1000 d 0 h 0],
  %w[3 札幌 4u g2 札幌記念 2000 t 0 s 0],
  %w[4 新潟 3 n nil 1200 d 0 a 0],
  %w[4 新潟 3 g3 新潟３歳S 1400 t 0 a 0],
  %w[4 新潟 4u m nil 1000 d 0 a 0],
  %w[4 新潟 4u m nil 1200 t f a 0],
  %w[4 新潟 4u 5 nil 1400 t 0 a 0],
  %w[4 新潟 4u 5 八海山特別 1700 t 0 a 0],
  %w[4 新潟 4u 5 新津特別 2000 t f a 0],
  %w[4 新潟 4u 9 弥彦特別 1600 t 0 h 0],
  %w[4 新潟 4u 16 越後S 1200 d 0 a 0],
  %w[4 小倉 3 n nil 1200 t 0 a 0],
  %w[4 小倉 3 g3 小倉３歳S 1200 t 0 a 0],
  %w[4 小倉 4u m nil 1000 d 0 a 0],
  %w[4 小倉 4u m nil 1800 t 0 a 0],
  %w[4 小倉 4u m nil 1000 d f a 0],
  %w[4 小倉 4u 5 唐津特別 1700 d 0 a 0],
  %w[4 小倉 4u 5 青島特別 1800 t 0 a 0],
  %w[4 小倉 4u 9 不知火特別 1800 t 0 a 0],
  %w[4 小倉 4u 16 博多S 2000 t 0 h 0],
  %w[4 札幌 3 n nil 1000 d 0 a 0],
  %w[4 札幌 3 m nil 1200 t 0 a 0],
  %w[4 札幌 3 o クローバー賞 1500 t 0 s 0],
  %w[4 札幌 4u m nil 1000 d 0 a 0],
  %w[4 札幌 4u m nil 2000 t 0 a 0],
  %w[4 札幌 4u 5 nil 1000 d 0 a 0],
  %w[4 札幌 4u 5 千歳特別 1700 d 0 a 0],
  %w[4 札幌 4u 9 UHB賞 2600 t 0 a 0],
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
