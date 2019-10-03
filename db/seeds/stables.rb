[
  Jockey,
  Stable
].each do |model|
  model.destroy_all
end

[
  %w[藤枝 美浦 馬に無理をさせず高勝率を誇る 小田部 橋野戸],
  %w[河原 美浦 じっくりと馬を育て長距離が得意 田名勝 吉臣],
  %w[奥形 美浦 休み明けでもきっちりと仕上げる 横乗 的庭],
  %w[秋野 美浦 逃げ先行馬を育てるのが得意 中縦 犬塚],
  %w[浅原 美浦 科学的トレーニングを取り入れ躍進中 海老正 加登],
  %w[森山 栗東 ハード調教で馬を鍛えて強くする 田茨 鉄造],
  %w[山藤 栗東 仕上げが早く３歳戦には特に強い 村元 四井],
  %w[古窪 栗東 レースを使いながら馬を仕上げる 滝登 南見],
  %w[佐浜 栗東 体調管理がうまく短距離戦に強い 河打 津野田],
  %w[小池 栗東 馬を大事に使うので故障が少ない 不二田 熊田],
].each do |name, c_name, desc, j_name1, j_name2|
  center = Center.find_by(name: c_name)
  Stable.create!(name: name, center: center, description: desc) { |s|
    s.jockeys << Jockey.create!(name: j_name1) \
              << Jockey.create!(name: j_name2)
  }
end
