class Ranch < ApplicationRecord
  has_many :ranch_mares, dependent: :destroy
  has_many :mares, through: :ranch_mares
  has_many :racers

  def month_week
    MonthWeek.new(month, week)
  end

  def go_to_next_week
    next_week = month_week.next
    attrs = next_week.to_params
    attrs.merge!(year: year + 1) if next_week.first_of_year?

    ApplicationRecord.transaction do
      update!(attrs)
      racers.each do |racer|
        racer.change_grade_to_no_win!
      end
    end
  end
end
