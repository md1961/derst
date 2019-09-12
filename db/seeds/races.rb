[
  Race
].each do |model|
  model.destroy_all
end

[
  # age constant separate handicap
  %w[5 3 東京 4 g1 日本ダービー ダービー t a 5000],
].each do |month, week, course_name, age, grade_name, name, abbr, surface, weight, prize1|
  course = Course.find_by(name: course_name)
  raise "Cannot find Course '#{course_name}' for m#{month}-w#{week}" unless course

  grade_name.upcase!
  grade_name = '新'  if grade_name == 'N'
  grade_name = '未'  if grade_name == 'M'
  grade_name = 'OP'  if grade_name == 'O'
  grade_name = 'GⅢ' if grade_name == 'G3'
  grade_name = 'GⅡ' if grade_name == 'G2'
  grade_name = 'GⅠ' if grade_name == 'G1'
  grade = Grade.find_by(abbr: grade_name) || Grade.find_by(name: grade_name)
  raise "Cannot find Course '#{grade_name}' for m#{month}-w#{week}" unless grade

  abbr = nil if abbr == 'nil'

  is_turf = surface.upcase != 'D'

  weight = {a: 1, c: 2, s: 3, h: 4}[weight[0].downcase.to_sym]

  Race.create!(
    month:   month.to_i,
    week:    week.to_i,
    course:  course,
    age:     age,
    grade:   grade,
    name:    name,
    abbr:    abbr,
    is_turf: is_turf,
    weight:  weight,
    prize1:  prize1 && prize1.to_i
  )
end
