module StringUtil
  module_function

  def extract_horse_names(str)
    return [] if str.blank?
    str.split(/[^\p{katakana}ー]+/)
  end

  def monetary_display(prize)
    prize = prize.to_i
    upper = prize >= 10000 ? "#{prize / 10000}億" : ""
    prize %= 10000
    lower = "#{upper.empty? ? prize : prize.to_s.rjust(4, '0')}万円"
    upper + lower
  end
end
