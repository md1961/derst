class Racer < ApplicationRecord
  include Ageable

  belongs_to :father, class_name: 'Sire'
  belongs_to :mother, class_name: 'Mare'
  belongs_to :ranch
  belongs_to :grade_given, class_name: 'Grade', optional: true
  belongs_to :stable, optional: true
  has_many :weeklies, -> { order(:age, :month, :week) }
  has_many :target_races
  has_one :in_ranch
  has_one :racer_trip
  has_one :course_staying, through: :racer_trip, source: :course
  has_one :injury
  has_many :handicap_loads

  has_many :results, -> { joins(:race).order(:age, 'races.month', 'races.week') } do
    def in_row_of_equal_or_better_place_of(place, high_stakes: false, n_grade: nil)
      find_all { |result|
        grade = result.race.grade
        !high_stakes || (n_grade.nil? && grade.high_stake?) || (n_grade == 1 && grade.g1?)
      }.chunk { |result|
        result.place && result.place <= place
      }.find_all { |is_equal_or_better, _|
        is_equal_or_better
      }.map { |_, results|
        results
      }.sort_by { |results|
        -results.size
      }
    end
  end

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

  def self.num_in_stable
    in_stable.count
  end

  def self.num_in_ranch
    active.count - num_in_stable - num_in_spa
  end

  def self.num_in_spa
    active.includes(:in_ranch).count { |racer| racer.in_spa? }
  end

  # FIXME: Correct self.all_training_done?() not to use Ranch.last.
  def self.all_training_done?(ranch = nil)
    ranch = Ranch.last unless ranch
    in_stable.joins(:weeklies)
             .where("weeklies.age = #{ranch.year} - racers.year_birth + 1")
             .where('weeklies.month': ranch.month, 'weeklies.week': ranch.week)
             .where("weeklies.condition > '' AND weeklies.weight > 0").count \
      == in_stable.count
  end

  def self.any_expecting_race?
    includes(:results).any?(&:expecting_race?)
  end

  def self.none_expecting_race?
    !any_expecting_race?
  end

  def open?
    grade&.abbr == 'OP'
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

  def in_spa?
    in_ranch&.is_in_spa
  end

  def to_be_trained?
    in_stable? && !(condition && weight)
  end

  def to_be_retired?
    weeklies.pluck(:condition).compact.last == '引'
  end

  def expecting_race?
    !results.empty? && results.last.place.blank?
  end

  def expecting_race
    return nil unless expecting_race?
    results.last.race
  end

  def target?(race)
    target_races.map(&:race).include?(race)
  end

  def needs_transport?
    return false if target_races.empty?
    coming_races_by_ordering = target_races.map(&:race).group_by { |race|
      race.month_week.ordering_from(ranch.month_week)
    }
    next_races = coming_races_by_ordering[coming_races_by_ordering.keys.min]
    next_races.any? { |next_race|
      !next_race.course.same_from?(stable) && next_race.course != course_staying
    }
  end

  def result_in(age, month, week)
    (
      @h_results ||= results.group_by { |result|
                       result.age_in_week.to_a
                     }.map { |age_in_week_in_a, results|
                       [age_in_week_in_a, results.first]
                     }.to_h
    )[[age, month, week]]
  end

  def race_in?(age, month, week)
    result_in(age, month, week).present?
  end

  def earns_net_prize_last_week?
    last_result = results.last
    last_result && last_result.age_in_week == age_in_week.prev && last_result.net_prize > 0
  end

  def coming_races
    last_result = results.last
    last_result = nil if last_result&.place.present?
    last_result = nil if last_result&.race == target_races.first&.race
    (
      [last_result] +
      target_races.reject { |r| r.race.month_week == last_result&.race&.month_week }
    ).compact
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

  def post_races
    results.map(&:post_race).compact
  end

  def mare
    Mare.find_by(name: name)
  end

  def age_in_week
    AgeInWeek.new(age, ranch.month, ranch.week)
  end

  def weight
    weeklies.find_by(age_in_week.to_h)&.weight
  end

  def weight=(value)
    value = nil if value.blank?
    weeklies.find_or_create_by!(age_in_week.to_h).update!(weight: value)
  end

  def last_weight
    weeklies.find_by(age_in_week.prev.to_h)&.weight || weight_best
  end

  def condition
    weeklies.find_by(age_in_week.to_h)&.condition
  end

  def weight_best_to_be_determined?
    return false if weight_best
    return false if weight_fat.nil?
    w = weight || last_weight
    w && weight_fat - w >= 4
  end

  def rest?
    %w[休 崩 疲 怪 引].include?(condition)
  end

  def condition=(value)
    params = {condition: value}
    params[:weight] = nil if value.blank?
    weeklies.find_or_create_by!(age_in_week.to_h).update!(params)
  end

  def default_condition
    return '引' if to_be_retired?
    return '重' if weeklies.empty?
    return '怪' if injury
    week_prev = age_in_week.prev
    return '休' if race_in?(*week_prev.to_a)
    (weeklies.find_by(week_prev.to_h)&.condition || '×').yield_self { |c|
      if c == '休'
        c = weeklies.find_by(week_prev.prev.to_h)&.condition
        c = '◉' if c == '◎'
      end
      c == '疲' ? '休' : (c == '崩' ? '↓' : c)
    }
  end

  def condition_in(age, month, week)
    the_week = AgeInWeek.new(age, month, week)
    return nil if the_week > age_in_week
    (
      @h_weeklies ||= weeklies.group_by { |weekly|
                        weekly.age_in_week.to_a
                      }.map { |age_in_week_in_a, weeklies|
                        [age_in_week_in_a, weeklies.first]
                      }.to_h
    )[the_week.to_a]&.condition || (the_week == age_in_week ? nil : '…')
  end

  def weeks_in_stable
    return 0 if in_ranch || stable.nil?
    week = age_in_week.prev
    while weeklies.find_by(week.to_h)
      week = week.prev
    end
    age_in_week - week
  end

  def weeks_in_ranch
    return 0 unless in_ranch
    ranch.month_week - in_ranch.month_week
  end

  def race_candidates(includes_overgrade: false)
    includes_overgrade = true if age == 4 && %w[5 9 16].include?(grade.abbr) && ranch.month <= 7
    return [] unless ranch && age && grade
    Race.for_racer(self, includes_overgrade: includes_overgrade)
        .in_or_after(ranch.month_week)
        .order(:month, :week)
        .includes(:grade, course: :area) \
    + \
    Race.for_racer(self, for_next_year: true, includes_overgrade: includes_overgrade)
        .before(ranch.month_week)
        .order(:month, :week)
        .includes(:grade, course: :area)
  end

  def main_jockeys
    stable&.jockeys || []
  end

  def last_jockey
    results.last&.jockey
  end

  def most_favorable_jockey
    h_num_rides_by_jockey.reject { |jockey, _|
      jockey.short_term?
    }.first.first
  end

  def h_num_rides_by_jockey
    return {} if results.empty?
    results.includes(:jockey).group_by(&:jockey).reject { |jockey, _|
      jockey.nil?
    }.map { |jockey, results|
      [jockey, results.size]
    }.sort_by { |jockey, num_rides|
      [-num_rides, jockey.main_for?(self) ? 0 : 1, jockey.id]
    }.to_h
  end

  def ordering_for_list
    [year_birth, stable_id || 9999] + orderings_from_mating + [name]
  end

  def place_records(high_stakes: false, n_grade: nil)
    _results = results
    _results = _results.high_stake(n_grade) if high_stakes
    [_results.size] \
    + _results.pluck(:place).group_by(&:to_i).find_all { |place, _|
        place <= 3
      }.map { |place, places|
        [place, places.size]
      }.to_h.fetch_values(1, 2, 3) { 0 }
  end

  def major_wins
    results_won_by_grade = results.where(place: 1).group_by { |result| result.race.grade }
    max_grade = results_won_by_grade.keys.find_all { |g|
      g.ordering >= Grade.find_by(abbr: 'OP').ordering
    }.sort_by(&:ordering).last
    results_won = results_won_by_grade[max_grade] || []

    results_runner_up_by_grade = results.where(place: 2).group_by { |result| result.race.grade }
    max_grade_runner_up = results_runner_up_by_grade.keys.find_all(&:high_stake?)
      .sort_by(&:ordering).last
    max_grade_runner_up = nil if max_grade && max_grade_runner_up \
                                 && max_grade_runner_up.ordering < max_grade.ordering
    results_runner_up = results_runner_up_by_grade[max_grade_runner_up] || []

    if max_grade_runner_up.nil? || max_grade_runner_up.g1?
      results_runner_up += results.joins(race: :grade).where("grades.abbr = 'Ⅰ' AND place >= 3")
                                  .group_by(&:place).sort_by { |place, _| place }.first&.last || []
    end

    [results_won, results_runner_up]
  end

  def create_mare
    return nil unless female?
    Mare.create_from_mating_of(mother, father, name)
  end

  def create_sire
    return nil unless male?
    Sire.create_from_mating_of(mother, father, name)
  end

  NUM_WEEKS_TO_DESTROY_TARGET_RACES_WHEN_GRAZE = 6

  def graze!
    create_in_ranch!(month: ranch.month, week: ranch.week)

    month_week = ranch.month_week
    NUM_WEEKS_TO_DESTROY_TARGET_RACES_WHEN_GRAZE.times do |n|
      target_races.in_week_of(month_week.month, month_week.week).destroy_all
      month_week = month_week.next
    end

    racer_trip&.destroy
  end

  def ungraze!
    in_ranch&.destroy
    injury&.destroy
  end

  def spa!
    graze! unless in_ranch
    in_ranch.update!(is_in_spa: true)
  end

  def trip_to(course)
    return unless course.stayable?

    course_race_hokkaido = ranch.courses_with_races.detect(&:hokkaido?)
    course = course_race_hokkaido if course.hokkaido? && course_race_hokkaido

    racer_trip&.destroy
    create_racer_trip(course: course)
  end

  def trip_back
    racer_trip.destroy
  end

  def injure(description)
    if description.blank?
      injury&.destroy
    elsif injury
      injury.update!(description: description)
    else
      create_injury!(description: description)
    end
  end

  def retire!
    update!(is_active: false)
    target_races.destroy_all
    injure(nil)
  end

  def data_for_race_load
    {
      wins: (1 .. 3).map { |n_grade|
        [n_grade, results.high_stake(n_grade).where("results.age > 3").wins.count]
      }.to_h,
      net_prize: net_prize
    }
  end

  def to_s
    name
  end

  private

    def orderings_from_mating
      score_from_mother = if mother.speed
                            mother.speed + mother.stamina
                          else
                            mother.racer_before_retire.net_prize.to_f / 10000
                          end
      [-score_from_mother, -father.trait.fee]
    end

  class AgeInWeek
    include Comparable

    attr_reader :age, :month, :week

    def initialize(age, month, week)
      @age   = age
      @month = month
      @week  = week
    end

    def prev
      month_week = MonthWeek.new(month, week).prev
      self.class.new(
        age - (month_week.last_of_year? ? 1 : 0),
        month_week.month,
        month_week.week
      )
    end

    def -(other)
      month_week       = MonthWeek.new(month, week)
      other_month_week = MonthWeek.new(other.month, other.week)
      month_week - other_month_week + (month < other.month ? 0 : (age - other.age) * 4 * 12)
    end

    def to_a
      [age, month, week]
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
end
