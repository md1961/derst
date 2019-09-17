class Racer < ApplicationRecord
  belongs_to :father, class_name: 'Sire'
  belongs_to :mother, class_name: 'Mare'
  belongs_to :ranch
  belongs_to :grade , optional: true
  belongs_to :stable, optional: true
  has_many :results

  enum sex: {male: 1, female: 2, gelding: 3}

  validates :name, presence: true, uniqueness: true

  def age
    return nil unless year_birth
    ranch.year - year_birth + 1
  end

  def age=(value)
    self.year_birth = value.blank? ? nil : ranch.year - value.to_i + 1
  end

  def race_candidates(includes_overgrade: false)
    return [] unless ranch && age && grade
    Race.for_racer(self, includes_overgrade: includes_overgrade)
        .in_or_after(ranch.month, ranch.week)
        .order(:month, :week) \
    + \
    Race.for_racer(self, for_next_year: true, includes_overgrade: includes_overgrade)
        .before(ranch.month, ranch.week)
        .order(:month, :week) \
  end
end
