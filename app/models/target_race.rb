class TargetRace < ApplicationRecord
  belongs_to :racer
  belongs_to :race

  scope :in_week_of, ->(month_week) {
    joins(:race).where("month = ? AND week = ?", *month_week.to_a)
  }
end
