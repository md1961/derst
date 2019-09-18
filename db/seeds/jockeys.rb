%w[
  小田部 的庭 横乗 吉臣 田名勝 海老正 中縦 橋野戸 加登
  江戸 良田 板井 大咲 犬塚 田間木 安登美 聴沢徳 △青地 ▲槙原
  滝登 南見 河打 不二田 松三木 田茨 津野田 騎士 村元
  四井 鉄造 福長 熊田 潮村 松昌 安田靖 土碑 △知田 ▲細井
].each do |name|
  next if Jockey.exists?(name: name)
  Jockey.create!(name: name)
end
