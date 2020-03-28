class TargetRace < ApplicationRecord
  belongs_to :racer
  belongs_to :race

  scope :in_week_of, ->(month, week) {
    joins(:race).where("month = ? AND week = ?", month, week)
  }

  scope :in_weeks_of, ->(month_weeks) {
    joins(:race).where(
      month_weeks.map { |_| "month = ? AND week = ?" }.join(' OR '),
      *month_weeks.flat_map { |month_week| month_week.to_a }
    )
  }

  scope :undergrade, ->(grade) {
    joins(race: :grade).where("ordering < ?", grade.ordering)
  }
end
