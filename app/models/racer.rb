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
  scope :in_ranch, -> {
    relation = active.eager_load(:in_ranch)
    relation.where("in_ranches.racer_id > 0").or(relation.where(stable: nil))
  }
  scope :older_first, -> { order(:year_birth) }

  validates :name, presence: true, uniqueness: true

  def self.num_in_ranch
    active.count - in_stable.count
  end

  def self.all_training_done?
    in_stable.includes(:weeklies).map(&:condition).all?
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

  def in_stable?
    is_active && stable && !in_ranch
  end

  def expecting_race?
    !results.empty? && results.last.place.blank?
  end

  def target?(race)
    target_races.map(&:race).include?(race)
  end

  def result_in(age, month, week)
    results.joins(:race).find_by(age: age, 'races.month': month, 'races.week': week)
  end

  def race_in?(age, month, week)
    result_in(age, month, week).present?
  end

  def coming_races
    last_result = results.last
    last_result = nil if last_result&.place.present?
    last_result = nil if last_result&.race == target_races.first&.race
    ([last_result] + target_races).compact
  end

  def active_age
    is_active ? age : weeklies.pluck(:age).max || 3
  end

  def downgrade_in_summer?
    age == 5 && ranch.month <= 7 \
      && (
           (grade.abbr == 'OP' && net_prize <= 3200) \
        || (grade.abbr == '16' && net_prize <= 1800) \
        || (grade.abbr ==  '9' && net_prize <= 1000)
      )
  end

  def mare
    Mare.find_by(name: name)
  end

    class AgeInWeek
      include Comparable

      attr_reader :age, :month, :week

      def initialize(age, month, week)
        @age   = age
        @month = month
        @week  = week
      end

      def to_h
        {age: age, month: month, week: week}
      end

      def <=>(other)
        [age <=> other.age, month <=> other.month, week <=> other.week].find { |cmp|
          !cmp.zero?
        } || 0
      end
    end

  def age_in_week
    AgeInWeek.new(age, ranch.month, ranch.week)
  end

  def condition
    weeklies.find_by(age: age, month: ranch.month, week: ranch.week)&.condition
  end

  def condition=(value)
    weeklies.find_or_create_by!(age: age, month: ranch.month, week: ranch.week).update!(condition: value)
  end

  def last_condition
    return '重' if weeklies.empty?
    month_week = ranch.month_week.prev
    _age = age - (month_week.last_of_year? ? 1 : 0)
    month, week = month_week.to_a
    return '休' if race_in?(_age, month, week)
    weeklies.find_by(
      age: _age,
      month: month,
      week: week
    )&.condition || '×'
  end

  def condition_in(age, month, week)
    return nil if age > self.age ||
                 (age == self.age && month > ranch.month) ||
                 (age == self.age && month == ranch.month && week > ranch.week)
    weeklies.find_by(age: age, month: month, week: week)&.condition ||
        (age == self.age && month == ranch.month && week == ranch.week ? nil : '…')
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

  def major_wins
    results_won_by_grade = results.where(place: 1).group_by { |result| result.race.grade }
    max_grade = results_won_by_grade.keys.find_all { |g|
      g.ordering >= Grade.find_by(abbr: '16').ordering
    }.sort_by(&:ordering).last

    results_runner_up_by_grade = results.where(place: 2).group_by { |result| result.race.grade }
    max_grade_runner_up = results_runner_up_by_grade.keys.find_all(&:high_stake?)
      .sort_by(&:ordering).last

    return [] if max_grade.nil? && max_grade_runner_up.nil?
    [results_won_by_grade[max_grade], results_runner_up_by_grade[max_grade_runner_up]]
  end

  def create_mare
    return nil unless female?
    Mare.transaction do
      Mare.create!(name: name, father: father, lineage: father.trait.lineage).tap { |mare|
        mare.maternal_lines.create!(generation: 2, father: mother.father)
        mare.maternal_lines.create!(generation: 3, father: mother.bloodline_father(2, 2))
        mare.maternal_lines.create!(generation: 4, father: mother.bloodline_father(3, 4))
      }
    end
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
