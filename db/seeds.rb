[
  Mare,
].each do |model|
  model.destroy_all
end

File.open('db/mares.txt') do |f|
  count = 1
  while line = f.gets
    next if line.starts_with?('馬名')
    name, lineage_name, price, speed, stamina, has_child, rating, type = line.split
    lineage = Lineage.find_by(name: lineage_name.chomp('系'))
    raise "Cannot find Lineage '#{lineage_name}' for '#{name}'" unless lineage

    mare = Mare.create!(
      name:      name,
      lineage:   lineage,
      price:     price.to_i,
      speed:     speed.to_i,
      stamina:   stamina.to_i,
      has_child: has_child == 'あり',
      rating:    rating,
      type:      type
    )

    print "#{count} "
    count += 1
  end
  puts
end
