module Results::G1ByYearsHelper

  H_RACE_ABBR = {
    'フェブラリーS'    => 'フェブS',
    '天皇賞(春)'       => '天皇賞春',
    'NHKマイルC'       => 'NHKマC',
    'オークス'         => 'オークス',
    '日本ダービー'     => 'ダービー',
    '天皇賞(秋)'       => '天皇賞秋',
    'エリザベス女王杯' => 'エ女王杯',
    'マイルCS'         => 'マイルCS',
    'ジャパンC'        => 'ジャパンC',
    '阪神３歳牝馬S'    => '阪神３牝',
    '朝日杯３歳S'      => '朝日杯３',
  }

  def race_abbr_display(race)
    race.name.yield_self { |name| H_RACE_ABBR[name] || name.first(4) }
  end

  def places_display_in_td(results)
    places = results.map(&:place).sort
    race_id = results.first.race.id

    classes = ["race-#{race_id}"]
    classes << 'centered'
    classes << 'win' if places.first == 1
    classes << 'runner_up' if places.include?(2)

    places_display = places.first(2).join(', ').gsub('99', '－')
    places_display += "...(#{places.size})" if places.size > 2
    racers_display = results.sort_by(&:place).map { |r| "#{r.place}着 #{r.racer}" }.join('、')
    content_tag :td, class: classes.join(' '), data: {race_id: race_id} do
      concat content_tag :span, places_display, class: 'places'
      concat content_tag :span, racers_display, class: 'racers', hidden: true
    end
  end
end
