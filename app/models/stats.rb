module Stats
  module_function

  MIN_IN_ROW_OF_PLACE = {
    1 => 3,
    2 => 4,
    3 => 5
  }

  def each_result_in_row_of_equal_or_better_place_of(place, high_stakes: false, &block)
    Racer.all.flat_map { |racer|
      racer.results.in_row_of_equal_or_better_place_of(place, high_stakes: high_stakes)
    }.find_all { |results|
      results.size >= MIN_IN_ROW_OF_PLACE[place] - (high_stakes ? 1 : 0)
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
