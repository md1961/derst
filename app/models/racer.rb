class Racer < ApplicationRecord
  include Ageable

  belongs_to :father, class_name: 'Sire'
  belongs_to :mother, class_name: 'Mare'
  belongs_to :ranch
  belongs_to :grade_given, class_name: 'Grade', optional: true
  belongs_to :stable, optional: true
  has_many :results
  has_many :target_races
  has_many :weeklies
  has_one :in_ranch

  enum sex: {male: 1, female: 2, gelding: 3}

  attr_readonly :grade_id

  scope :active , -> { where(is_active: true ) }
  scope :retired, -> { where(is_active: false) }
  scope :in_stable, -> {
    active.where.not(stable: nil).eager_load(:in_ranch).where('in_ranches.racer_id': nil)
  }
  scope :older_first, -> { order(:year_birth) }

  validates :name, presence: true, uniqueness: true

  def self.num_in_ranch
    active.count - in_stable.count
  end

  def grade
    @grade ||= grade_given || grade_from_net_prize
  end

  def net_prize
    results.includes(race: :grade).map(&:net_prize).sum
  end

  def grade_from_net_prize
    return nil if stable.nil? && results.empty?
    np = net_prize
    np /= 2 if age >= 6 || (age == 5 && ranch.month >= 8)
    month = ranch.month
    abbr = if np > 1600
             'OP'
           elsif np > 900
             (age == 3 || (age == 4 && month <= 6)) ? 'OP' : '16'
           elsif np > 500
             (age == 3 || (age == 4 && month <= 5)) ? 'OP' : '9'
           elsif np > 0
             age == 3 && month <= 9 ? 'OP' : '5'
           elsif age == 3 && (results.empty? || results.first.race.month == ranch.month)
             '新'
           else
             '未'
           end
    Grade.find_by(abbr: abbr)
  end

  def expecting_race?
    !results.empty? && results.last.place.blank?
  end

  def target?(race)
    target_races.map(&:race).include?(race)
  end

  def race_in?(age, month, week)
    results.joins(:race).where(age: age, 'races.month': month, 'races.week': week).count > 0
  end

  # TODO: Take 'net prize' into account in #downgrade_in_summer?()
  def downgrade_in_summer?
    age == 5 && grade.ordering >= Grade.find_by(abbr: '9').ordering
  end

  def condition
    weeklies.find_by(age: age, month: ranch.month, week: ranch.week)&.condition
  end

  def condition=(value)
    weeklies.find_or_create_by!(age: age, month: ranch.month, week: ranch.week).update!(condition: value)
  end

  def race_candidates(includes_overgrade: false)
    includes_overgrade = true if age == 4 && %w[5 9 16].include?(grade.abbr) && ranch.month <= 7
    return [] unless ranch && age && grade
    Race.for_racer(self, includes_overgrade: includes_overgrade)
        .in_or_after(ranch.month_week)
        .order(:month, :week) \
    + \
    Race.for_racer(self, for_next_year: true, includes_overgrade: includes_overgrade)
        .before(ranch.month_week)
        .order(:month, :week) \
  end

  def place_records
    [results.size] \
    + results.pluck(:place).group_by(&:to_i).find_all { |place, _|
        place <= 3
      }.map { |place, places|
        [place, places.size]
      }.to_h.fetch_values(1, 2, 3) { 0 }
  end

  def change_grade_to_no_win!
    return unless grade&.new_racer?
    return if results.empty?
    return if results.first.race.month == ranch.month
    update!(grade: Grade.find_by(abbr: '未'))
  end

  def graze!
    create_in_ranch!(month: ranch.month, week: ranch.week)
  end

  def ungraze!
    in_ranch.destroy
  end

  def retire!
    update!(is_active: false)
  end

  def to_s
    name
  end
end
