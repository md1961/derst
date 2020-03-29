class RanchSire < ApplicationRecord
  belongs_to :ranch
  belongs_to :sire

  def year_left
    year_leased + 5 - ranch.year
  end
end
