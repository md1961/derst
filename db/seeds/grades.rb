[
  Grade
].each do |model|
  model.destroy_all
end

[
  %w[新馬 新],
  %w[未勝利 未],
  %w[500万下 5],
  %w[900万下 9],
  %w[1600万下 16],
  %w[オープン OP],
  %w[GⅢ],
  %w[GⅡ],
  %w[GⅠ],
].each.with_index(1) do |(name, abbr), ordering|
  Grade.create!(name: name, abbr: abbr, ordering: ordering)
end
