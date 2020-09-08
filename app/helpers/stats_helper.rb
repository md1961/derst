module StatsHelper

  def age_range_display(results)
    [results.first, results.last].map(&:age).uniq.map { |age| "#{age}歳" }.join('～')
  end

  def week_with_year_display(result)
    sprintf("%2d.%2d.%1d", result.year, result.race.month, result.race.week)
      .gsub(' ', '&nbsp;').html_safe
  end

  def week_range_display(results)
    [results.first, results.last].map { |result|
      week_with_year_display(result)
    }.join('&nbsp;～').html_safe
  end

  def races_display(results)
    results.map { |result|
      race_name_display(result.race) + result.place.yield_self { |p| p > 1 ? " #{p}着" : "" }
    }.join(' -> ').html_safe
  end

  def year_month_week_display(result)
    sprintf("%d.%2d.%1d", result.year, result.race.month, result.race.week)
  end
end
