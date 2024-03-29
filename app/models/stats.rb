module Stats
  module_function

  MIN_IN_ROW_OF_PLACE = {
    1 => [ 5, 4, 3],
    2 => [ 7, 6, 4],
    3 => [10, 8, 5]
  }

  def each_most_races(high_stakes: false, n_grade: nil, &block)
    counter = Counter.new
    Racer.all.includes(results: {race: :grade}).map { |racer|
      results = racer.results
      results = results.high_stake(n_grade) if high_stakes
      [racer, results.find_all(&:completed?).size]
    }.sort_by { |_, num|
      -num
    }.take_while { |_, num|
      counter.count(num)
    }.each(&block)
  end

  def each_result_in_row_of_equal_or_better_place_of(place, high_stakes: false, n_grade: nil, &block)
    counter = Counter.new
    Racer.all.includes(results: {race: :grade}).flat_map { |racer|
      racer.results.in_row_of_equal_or_better_place_of(place, high_stakes: high_stakes, n_grade: n_grade)
    }.sort_by { |results|
      -results.size
    }.take_while { |results|
      counter.count(results.size)
    }.each(&block)
  end

  def each_oldest_high_stake_win(&block)
    Racer.all.includes(results: {race: :grade}).flat_map { |racer|
      racer.results.high_stake.wins
    }.compact.sort_by(&:age_in_week).reverse.first(10).each(&block)
  end

  def each_youngest_or_oldest_old_horse_g1_win_by_race(youngest: true, &block)
    Result.includes(:racer, race: :grade)
          .high_stake(1).wins.old_horse_race
          .group_by(&:race).map { |race, results|
      [
        race,
        results.sort_by(&:age_in_week).yield_self { |results|
          target = youngest ? results.first : results.last
          results.find_all { |result|
            result.age_in_week == target.age_in_week
          }.sort_by(&:year)
        }
      ]
    }.sort_by { |race, _|
      [race.month, race.week, race.course_id]
    }.each(&block)
  end

  def each_most_number_of_equal_or_better_places_of(place, high_stakes: false, n_grade: nil, &block)
    counter = Counter.new
    Racer.all.includes(results: {race: :grade}).map { |racer|
      [racer, racer.place_records(high_stakes: high_stakes, n_grade: n_grade)[1 .. place].sum]
    }.sort_by { |_, number|
      -number
    }.take_while { |_, number|
      counter.count(number)
    }.each(&block)
  end

  MIN_RACES_FOR_BEST_PCT = [10, 5]

  def each_best_pct_of_equal_or_better_places_of(place, high_stakes: false, n_grade: n_grade, &block)
    counter = Counter.new
    Racer.all.includes(results: {race: :grade}).map { |racer|
      place_records = racer.place_records(high_stakes: high_stakes, n_grade: n_grade)
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

  def each_highest_odds_wins(high_stakes: false, n_grade: nil, &block)
    counter = Counter.new(20)
    results = high_stakes ? Result.high_stake(n_grade) : Result.all
    results.wins.reject { |result|
      result.odds.blank?
    }.sort_by { |result|
      -result.odds
    }.take_while { |result|
      counter.count(result.odds)
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
