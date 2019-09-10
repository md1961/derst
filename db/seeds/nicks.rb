[
  Nick,
].each do |model|
  model.destroy_all
end

line_num = 1
File.open('db/nicks.txt') do |f|
  while line = f.gets
    lineage1, lineage2 = line.split.map { |name|
      Lineage.find_by(name: name)
    }

    Nick.create!(lineage1: lineage1, lineage2: lineage2)

    line_num += 1
  end
end
