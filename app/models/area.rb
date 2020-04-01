class Area < ApplicationRecord

  def hokkaido?
    name == 'Hokkaido'
  end

  def same_from?(center)
    self == center.area
  end

  def on_the_day_from?(center)
    (location - center.area.location).abs <= 2
  end

  def oversea?
    name == 'Oversea'
  end
end
