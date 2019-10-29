require 'set'

class RacerNameSample < ApplicationRecord

  validates :name, presence: true, length: {in: 2 .. 9}

  after_initialize :name_to_katakana

  def self.combinations(num = 1)
    set = Set.new
    while set.size < num
      name0 = pluck(:name).find_all { |name| name.length <= 7                }.sample
      name1 = pluck(:name).find_all { |name| name.length <= 9 - name0.length }.sample
      names = [name0, name1].sort
      set << [names.join, names.reverse.join]
    end
    set
  end

  def to_s
    name
  end

  private

    using StringJapanese

    def name_to_katakana
      self.name = name&.to_katakana
    end
end
