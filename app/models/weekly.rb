class Weekly < ApplicationRecord
  belongs_to :racer

  def age_in_week
    Racer::AgeInWeek.new(age, month, week)
  end
end
