module StringUtil
  module_function

  def extract_horse_names(str)
    return [] if str.blank?
    str.split(/[^\p{katakana}ー]+/)
  end
end
