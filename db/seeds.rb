[
  Sire,
  RootLineage,
  Lineage,
].each do |model|
  model.destroy_all
end

%w[
  インテント系 エタン系 オリオール系 オーエンテューダー系 カーレッド系
  クラリオン系 グレイソヴリン系 サンインロー系 サーゲイロード系 スインフォード系
  ゼダーン系 ソヴリンパス系 ダンテ系 テディ系 トウルビヨン系
  トムフール系 ニアークティック系 ネイティヴダンサー系 ネヴァーベンド系 ノーザンダンサー系
  ハイペリオン系 ハビタット系 ヒムヤー系 ファイントップ系 フェアウェイ系
  フェアトライアル系 フォルティノ系 ブラントーム系 ブレニム系 プリンスキロ系
  プリンスビオ系 プリンスリーギフト系 プリンスローズ系 ヘイルトゥリーズン系 ボワルセル系
  ボールドルーラー系 マイバブー系 モスボロー系 リボー系 レイズアネイティヴ系
  レッドゴッド系 レリック系 ロイヤルチャージャー系 ロックフェラ系
].each do |name|
  Lineage.create!(name: name.chomp('系'))
end

[
  [ 1, 'ファロス'],
  [ 2, 'テディ'],
  [ 3, 'シックル'],
  [ 4, 'ハンプトン'],
  [ 5, 'ヒムヤー'],
  [ 6, 'ファラモンド'],
  [ 7, 'ヘロド'],
  [ 8, 'フェアウェイ'],
  [ 9, 'スインフォード'],
  [10, 'セントサイモン'],
  [11, 'マッチェム'],
  [12, 'エクリプス'],
  [13, 'ファラリス'],
].each do |number, name|
  RootLineage.create!(number: number, name: name)
end

File.open('db/sires.txt') do |f|
  count = 1
  while line = f.gets
    next if line.starts_with?('馬名')
    name, lineage_name, fee, min_distance, max_distance, dirt, \
        growth, temper, contend, health, achievement, stability = line.split
    lineage = Lineage.find_by(name: lineage_name.chomp('系'))
    raise "Cannot find Lineage '#{lineage_name}' for '#{name}'" unless lineage

    name.gsub!('_', ' ')
    key = Sire.english_name?(name) ? :name_eng : :name_jp
    sire = Sire.create!(key => name)

    sire.create_trait!(
      lineage:      lineage,
      fee:          fee,
      min_distance: min_distance,
      max_distance: max_distance,
      dirt:         dirt,
      growth:       growth,
      temper:       temper,
      contend:      contend,
      health:       health,
      achievement:  achievement,
      stability:    stability,
    )

    print "#{count} "
    count += 1
  end
  puts
end
