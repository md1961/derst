class Racer < ApplicationRecord
  belongs_to :ranch
  belongs_to :stable, optional: true

  def age
    return nil unless year_birth
    ranch.year - year_birth + 1
  end
end
