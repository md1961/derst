bases_and_additions = open('db/loads_separate.txt') { |f|
  f.each_line.map { |line|
    line.chomp.split('=').last.strip
  }.reject { |line|
    line.empty? || line.starts_with?('age')
  }.map { |line|
    line.split('  ')
  }
}

bases, additions = [0, 1].map { |i| bases_and_additions.map { |b_and_a| b_and_a[i] } }

h_bases = Hash.new(0).tap { |h|
  bases.each do |base|
    h[base] += 1
  end
}

h_additions = Hash.new(0).tap { |h|
  additions.each do |addition|
    h[addition] += 1
  end
}


width = h_bases.keys.map(&:size).max
h_bases.keys.sort.each do |base|
  printf("%-#{width}s : %2d\n", base, h_bases[base])
end

puts

width = h_additions.keys.map(&:size).max
h_additions.keys.sort.each do |addition|
  printf("%-#{width}s : %2d\n", addition, h_additions[addition])
end
