class Ranch < ApplicationRecord
  has_many :ranch_mares, dependent: :destroy
  has_many :mares, through: :ranch_mares
  has_many :racers

  def in_week_of?(month, week)
    self.month == month && self.week == week
  end

  def month_week
    MonthWeek.new(month, week)
  end

  def courses_with_races
    Course.where(id: Race.where(month: month).pluck(:course_id).uniq)
  end

  def go_to_next_week
    next_week = month_week.next
    attrs = next_week.to_params
    attrs.merge!(year: year + 1) if next_week.first_of_year?
    update!(attrs)
    return if week > 1

    courses_current = courses_with_races
    course_current_hokkaido = courses_current.detect(&:hokkaido?)
    RacerTrip.find_each do |trip|
      course = trip.course
      next if courses_current.include?(course)
      if course.hokkaido? && course_current_hokkaido
        trip.update!(course: course_current_hokkaido)
      else
        trip.destroy
      end
    end
  end
end
