module Stats
  module_function

  def each_wins_in_row(&block)
    Racer.all.flat_map { |racer|
      racer.results.wins_in_row
    }.find_all { |results|
      results.size >= 3
    }.sort_by { |results|
      -results.size
    }.each(&block)
  end

  def each_oldest_high_stake_win(&block)
    Racer.all.map { |racer|
      racer.results.high_stake.wins&.last
    }.compact.sort_by(&:age_in_week).reverse.each(&block)
  end

  def each_youngest_high_stake_win(&block)
    Racer.all.map { |racer|
      racer.results.high_stake.wins&.first
    }.compact.sort_by(&:age_in_week).each(&block)
  end
end
