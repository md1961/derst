class Earning
  attr_reader :year, :month, :results

  def self.all
    Result.includes(:racer, :race).group_by { |result|
      [result.year, result.race.month]
    }.map { |(year, month), results|
      new(year, month, results)
    }.sort_by { |earning|
      [earning.year, earning.month]
    }
  end

  def initialize(year, month, results)
    @year    = year
    @month   = month
    @results = results.find_all { |result| (result.prize rescue 0) > 0 }
  end

  def total
    results.map(&:prize).sum
  end

  def total_by_racer
    results.group_by(&:racer).map { |racer, results|
      [racer, results.map(&:prize).sum]
    }.reject { |_, total|
      total.nil?
    }
  end
end
