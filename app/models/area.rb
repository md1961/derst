class Area < ApplicationRecord

  def same_from?(center)
    self == center.area
  end

  def on_the_day_from?(center)
    (location - center.area.location).abs <= 2
  end
end
