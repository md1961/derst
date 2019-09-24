class Racer < ApplicationRecord
  include Ageable

  belongs_to :father, class_name: 'Sire'
  belongs_to :mother, class_name: 'Mare'
  belongs_to :ranch
  belongs_to :grade , optional: true
  belongs_to :stable, optional: true
  has_many :results
  has_many :target_races

  enum sex: {male: 1, female: 2, gelding: 3}

  scope :active , -> { where(is_active: true ) }
  scope :retired, -> { where(is_active: false) }

  validates :name, presence: true, uniqueness: true

  def target?(race)
    target_races.map(&:race).include?(race)
  end

  # TODO: Take 'net prize' into account in #downgrade_in_summer?()
  def downgrade_in_summer?
    age == 5 && grade.ordering >= Grade.find_by(abbr: '9').ordering
  end

  def race_candidates(includes_overgrade: false)
    return [] unless ranch && age && grade
    Race.for_racer(self, includes_overgrade: includes_overgrade)
        .in_or_after(ranch.month_week)
        .order(:month, :week) \
    + \
    Race.for_racer(self, for_next_year: true, includes_overgrade: includes_overgrade)
        .before(ranch.month_week)
        .order(:month, :week) \
  end

  def retire!
    update!(is_active: false)
  end
end
