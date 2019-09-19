class Ranch < ApplicationRecord
  has_many :ranch_mares, dependent: :destroy
  has_many :mares, through: :ranch_mares
  has_many :racers

  def month_week
    MonthWeek.new(month, week)
  end

  def weeks_later_of(month, week)
    if month == self.month
      diff = week - self.week
      diff += 4 * 12 if diff < 0
    else
      month_diff = month - self.month
      month_diff += 12 if month_diff < 0
      diff = month_diff * 4 + week - self.week
    end
    diff
  end

  def go_to_next_week
    attrs = {week: week + 1}
    if attrs[:week] > 4
      attrs[:week] = 1
      attrs[:month] = month + 1
      if attrs[:month] > 12
        attrs[:month] = 1
        attrs[:year] = year + 1
      end
    end
    update!(attrs)
  end
end
