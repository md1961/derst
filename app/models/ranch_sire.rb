class RanchSire < ApplicationRecord
  belongs_to :ranch
  belongs_to :sire

  def self.destroy_lease_expiring
    return if count.zero?
    ranch = first.ranch
    return if ranch.month < 6
    all.find_all { |ranch_sire| ranch_sire.year_left == 1 }.map(&:destroy)
  end

  def year_left
    year_leased + 5 - ranch.year
  end
end
