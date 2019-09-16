class Area < ApplicationRecord

  def on_the_day_from?(center)
    (location - center.area.location).abs <= 2
  end
end
