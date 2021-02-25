module Results::G1ByRacersHelper

  H_RACE_ABBR = {
    'フェブラリーS'    => 'フブ',
    '天皇賞(春)'       => '天春',
    'NHKマイルC'       => 'Nマ',
    'オークス'         => 'オク',
    '日本ダービー'     => 'ダビ',
    '天皇賞(秋)'       => '天秋',
    'エリザベス女王杯' => 'エ女',
    'マイルCS'         => 'マC',
    'ジャパンC'        => 'JC',
    '阪神３歳牝馬S'    => '阪３',
    '朝日杯３歳S'      => '朝３',
  }

  def race_abbr_display(race)
    race.name.yield_self { |name| H_RACE_ABBR[name] || name.first(2) }
  end
end
