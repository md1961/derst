module MaresHelper

  def g1_wins_display(kind, racer)
    return (kind == :count ? '－' : '') unless racer
    results = racer.results.wins.find_all { |result| result.race.grade.g1? }
    kind == :count ? "#{results.size}勝" : results.map(&:race).map(&:name).join('、')
  end
end
