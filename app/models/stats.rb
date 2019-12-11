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
end
