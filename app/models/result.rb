class Result < ApplicationRecord
  belongs_to :racer
  belongs_to :race
  belongs_to :jockey, optional: true
  has_one :post_race

  before_save :decrease_load, if: -> { jockey && race.name.nil? }

  validates :place, inclusion: {in: (1 .. 16).to_a + [99]}, allow_nil: true

  scope :high_stake, ->(n_grade = nil) {
    if n_grade.nil?
      joins(race: :grade).where("grades.abbr IN (#{%w['Ⅰ' 'Ⅱ' 'Ⅲ'].join(',')})")
    else
      abbr = {1 => 'Ⅰ', 2 => 'Ⅱ', 3 => 'Ⅲ'}[n_grade]
      raise "Illegal n_grade (#{n_grade.inspect})" unless abbr
      joins(race: :grade).where("grades.abbr = '#{abbr}'")
    end
  }

  scope :in_current_week, ->(ranch = nil) {
    ranch = Ranch.last unless ranch
    Result.joins(:racer, :race)
          .where("results.age = #{ranch.year} - racers.year_birth + 1")
          .where('races.month': ranch.month, 'races.week': ranch.week)
  }

  scope :wins, -> { where(place: 1) }

  scope :num_races, -> { joins(:race).select('races.id').distinct.count }
  scope :num_races_in_current_week, -> { in_current_week.num_races }
  scope :num_races_yet_to_come    , -> { in_current_week.where(place: nil).num_races }
  scope :num_racers_in_race_in_current_week, -> { in_current_week.count }

  def self.multiple_entries
    high_stake(1).includes(:racer, :race).group_by { |result|
      [result.year, result.race]
    }.find_all { |_, results|
      results.size >= 2
    }.map(&:last).map { |results|
      results.sort_by(&:place)
    }.sort_by { |results|
      (results.map(&:place) + [99] * 8).first(8)
    }
  end

  def self.rivalries
    includes(:racer, :race).group_by { |result|
      [result.year, result.race]
    }.find_all { |_, results|
      results.size >= 2
    }.flat_map { |_, results|
      results.combination(2).to_a
    }.group_by { |results|
      results.map(&:racer_id).sort
    }.sort_by { |_, array_of_results|
      -array_of_results.size
    }.tap { |results_by_racers|
      array_of_results = results_by_racers.flat_map(&:last)
      raise "Different races!" unless array_of_results.all? { |results|
        results.size == 2 && results.map { |result| [result.year, result.race_id] }.uniq.size == 1
      }
    }
  end

  def completed?
    num_racers.present? && place.present? && comment_race.present?
  end

  def did_not_finish?
    place && place > 20
  end

  def net_prize
    return 0 unless place
    race.net_prize_for(place)
  end

  def prize
    return 0 unless place
    race.prize_for(place)
  end

  def age_in_week
    Racer::AgeInWeek.new(age, race.month, race.week)
  end

  def year
    racer.year_birth + age - 1
  end

  def ordering
    [year, race.month, race.week, race.grade.ordering]
  end

  def set_load_from_racer_and_race!
    value = race.load_for(racer)
    return unless value
    update!(load: value)
  end

  private

    def decrease_load
      self.load = race.load_for(racer) - jockey.load_decrement
    end
end
