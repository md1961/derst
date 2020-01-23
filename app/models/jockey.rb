class Jockey < ApplicationRecord
  belongs_to :center
  belongs_to :stable, optional: true

  def self.short_term_jockey_in(month)
    name = case month
           when 3 .. 5
             'ロバーツ'
           when 6 .. 8
             'リサ'
           when 9 .. 11
             'ムンロ'
           else
             'ペリエ'
           end
    find_by(name: name)
  end

  def short_term?
    center.short_stay?
  end

  def main_for?(racer)
    stable == racer.stable
  end

  def same_center_with?(racer)
    center == racer.stable&.center
  end

  def center_and_stable
    "#{center}#{center.short_stay? ? '' : stable ? ' 専属' : ''}"
  end

  def load_decrement
    {'△': 1, '▲': 3}.fetch(name[0].to_sym, 0)
  end

  def to_s
    name
  end
end
