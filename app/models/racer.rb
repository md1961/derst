class Racer < ApplicationRecord
  belongs_to :ranch
  belongs_to :stable, optional: true

  enum sex: {male: 1, female: 2, gelding: 3}

  def age
    return nil unless year_birth
    ranch.year - year_birth + 1
  end
end
