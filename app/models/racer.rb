class Racer < ApplicationRecord
  belongs_to :father, class_name: 'Sire'
  belongs_to :mother, class_name: 'Mare'
  belongs_to :ranch
  belongs_to :stable, optional: true

  enum sex: {male: 1, female: 2, gelding: 3}

  validates :name, presence: true, uniqueness: true

  def age
    return nil unless year_birth
    ranch.year - year_birth + 1
  end

  def age=(value)
    self.year_birth = value.blank? ? nil : ranch.year - value.to_i + 1
  end
end
