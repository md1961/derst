class Course < ApplicationRecord
  belongs_to :area

  def hokkaido?
    area.hokkaido?
  end

  def stayable?
    !%w[Kanto Kansai].include?(area.name)
  end

  def same_area_with?(other)
    self == other || (hokkaido? && other.hokkaido?)
  end

  def same_from?(stable)
    area.same_from?(stable.center)
  end

  def on_the_day_from?(stable)
    area.on_the_day_from?(stable.center)
  end

  def needs_trip_from?(stable)
    !on_the_day_from?(stable)
  end

  def oversea?
    area.oversea?
  end

  def to_s
    name
  end
end
