require 'nkf'

module StringJapanese

  refine String do

    def to_katakana
      NKF.nkf('-w --katakana', self)
    end
  end
end
