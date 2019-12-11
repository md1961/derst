module StatsHelper

  def age_range_display(results)
    [results.first, results.last].map(&:age).uniq.map { |age| "#{age}歳" }.join('～')
  end

  def week_in_age_display(result)
    sprintf("%2d.%2d.%1d", result.year, result.race.month, result.race.week)
      .gsub(' ', '&nbsp;').html_safe
  end

  def week_range_display(results)
    [results.first, results.last].map { |result|
      week_in_age_display(result)
    }.join('&nbsp;～').html_safe
  end

  def races_display(races)
    races.map { |race|
      race_name_display(race)
    }.join(' -> ').html_safe
  end
end
