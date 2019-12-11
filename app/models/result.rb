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

  scope :wins, -> { where(place: 1) }

  def net_prize
    return 0 unless place
    race.net_prize_for(place)
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
