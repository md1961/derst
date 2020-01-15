module Stats
  module_function

  MIN_IN_ROW_OF_PLACE = {
    1 => [3, 2],
    2 => [4, 3],
    3 => [5, 4]
  }

  def each_result_in_row_of_equal_or_better_place_of(place, high_stakes: false, &block)
    Racer.all.includes(results: {race: :grade}).flat_map { |racer|
      racer.results.in_row_of_equal_or_better_place_of(place, high_stakes: high_stakes)
    }.find_all { |results|
      results.size >= MIN_IN_ROW_OF_PLACE[place][high_stakes ? 1 : 0]
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

  def each_most_number_of_equal_or_better_places_of(place, high_stakes: false, &block)
    counter = Counter.new
    Racer.all.includes(results: {race: :grade}).map { |racer|
      [racer, racer.place_records(high_stakes: high_stakes)[1 .. place].sum]
    }.sort_by { |_, number|
      -number
    }.take_while { |_, number|
      counter.count(number)
    }.each(&block)
  end

  MIN_RACES_FOR_BEST_PCT = [10, 5]

  def each_best_pct_of_equal_or_better_places_of(place, high_stakes: false, &block)
    counter = Counter.new
    Racer.all.includes(results: {race: :grade}).map { |racer|
      place_records = racer.place_records(high_stakes: high_stakes)
      num_races = place_records[0]
      if num_races < MIN_RACES_FOR_BEST_PCT[high_stakes ? 1 : 0]
        nil
      else
        [racer, place_records[1 .. place].sum, num_races]
      end
    }.compact.sort_by { |_, num_places, num_races|
      -num_places.to_f / num_races
    }.take_while { |_, num_places, num_races|
      counter.count(num_places.to_f / num_races)
    }.each(&block)
  end

    class Counter

      def initialize(max_count = 10)
        @max_count = max_count
        @count = 0
        @value_to_cut = 0
      end

      def count(value)
        @count += 1
        @value_to_cut = value if @count == @max_count
        @count <= @max_count || value >= @value_to_cut
      end
    end
end
