module StatsHelper

  H_LABEL_FOR_TABNAVI = {
    g1_wins:           'GⅠ成績',
    high_stake_wins:   '重賞成績',
    allover_wins:      '全成績',
    num_wins:          '勝利数',
    win_pcts:          '勝率',
    wins_in_row:       '連勝',
    oldest_wins:       '最年長勝利',
    highest_odds_wins: '最高オッズ勝利'
  }

  def label_for_tabnavi(page_name)
    H_LABEL_FOR_TABNAVI[page_name.to_sym]
  end

  def racer_as_link(racer)
    link_to racer.name, racer_path(racer, top_bar: false), target: '_blank', class: 'no_style'
  end

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
