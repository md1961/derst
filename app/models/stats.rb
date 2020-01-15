module Stats
  module_function

  MIN_IN_ROW_OF_PLACE = {
    1 => 3,
    2 => 4,
    3 => 5
  }

  def each_result_in_row_of_equal_or_better_place_of(place, high_stakes: false, &block)
    Racer.all.includes(results: {race: :grade}).flat_map { |racer|
      racer.results.in_row_of_equal_or_better_place_of(place, high_stakes: high_stakes)
    }.find_all { |results|
      results.size >= MIN_IN_ROW_OF_PLACE[place] - (high_stakes ? 1 : 0)
    }.sort_by { |results|
      -results.size
    }.each(&block)
  end

  def each_oldest_high_stake_win(&block)
    Racer.all.includes(results: {race: :grade}).map { |racer|
      racer.results.high_stake.wins&.last
    }.compact.sort_by(&:age_in_week).reverse.each(&block)
  end

  def each_youngest_high_stake_win(&block)
    Racer.all.includes(results: {race: :grade}).map { |racer|
      racer.results.high_stake.wins&.first
    }.compact.sort_by(&:age_in_week).each(&block)
  end

  MIN_NUMBER_OF_PLACES = {
    1 => [ 6,  2],
    2 => [10,  2],
    3 => [13,  3]
  }

  def each_most_number_of_equal_or_better_places_of(place, high_stakes: false, &block)
    Racer.all.includes(results: {race: :grade}).map { |racer|
      [racer, racer.place_records(high_stakes: high_stakes)[1 .. place].sum]
    }.find_all { |_, number|
      number >= MIN_NUMBER_OF_PLACES[place][high_stakes ? 1 : 0]
    }.sort_by { |_, number|
      -number
    }.each(&block)
  end
end
