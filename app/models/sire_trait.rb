class SireTrait < ApplicationRecord
  belongs_to :sire
  belongs_to :lineage

  def distances
    "#{min_distance}～#{max_distance}"
  end
end
