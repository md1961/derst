ApplicationRecord.transaction do

oversea = Area.create!(name: 'Oversea', location: -99)

%w[英国 米国 仏国].each do |name|
  Course.create!(name: name, area: oversea)
end

#  7.4 英 キングジョージ6世&クイーンエリザベスS  天皇賞・春         & G1 > 2200m 3win
#  9.1 米 アーリントンミリオンS                  KG6QES win OR 宝塚 & G1 > 2200m 3win
# 10.1 仏 凱旋門賞                               KG6QES win OR 宝塚 & G1 > 2200m 3win
#                                                １ヶ月前に入厩していると打診がある。

g1 = Grade.find_by(abbr: 'Ⅰ')
raise "Cannot find Grade G1" unless g1

[
  [ 7, 4, '英国', 'KG VI & QE S',   2406],
  [ 9, 1, '米国', 'アーリントンMS', 2011],
  [10, 1, '仏国', '凱旋門賞',       2400]
].each do |month, week, course_name, name, distance|
  course = Course.find_by(name: course_name)
  raise "Cannot find Course with name of '#{course_name}'" unless course
  Race.create!(
    month:    month,
    week:     week,
    course:   course,
    age:      '5U',
    grade:    g1,
    name:     name,
    surface:  'turf',
    distance: distance,
    weight:   'constant',
  )
end

end
