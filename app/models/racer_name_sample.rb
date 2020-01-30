require 'set'

class RacerNameSample < ApplicationRecord
  self.inheritance_column = :_type_disabled

  enum type: {no_type: 0, full_name: 1, dual_use: 2, prefix: 3, postfix: 4}
  enum sex:  {unisex: 0, male: 1, female: 2}

  validates :name, presence: true, uniqueness: true, length: {in: 2 .. 9}

  after_initialize :name_to_katakana

  def self.most_similars(name, num = 10)
    all.map { |sample|
      [sample.name, normalized_distance(name, sample.name), name]
    }.sort_by { |_, distance, _|
      distance
    }.take(num)
  end

  def self.group_by(item)
    order(:name).group_by(&item.to_sym).map { |item, samples| [item, samples] }.to_h
  end

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

    def self.normalized_distance(str1, str2)
      DamerauLevenshtein.distance(str1, str2).to_f / [str1, str2].map(&:length).max
    end

    using StringJapanese

    def name_to_katakana
      self.name = name&.to_katakana
    end
end
