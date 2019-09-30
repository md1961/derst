class InRanch < ApplicationRecord
  belongs_to :racer

  def month_week
    MonthWeek.new(month, week)
  end
end
