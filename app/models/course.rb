class Course < ApplicationRecord
  belongs_to :area

  def same_from?(stable)
    area.same_from?(stable.center)
  end

  def on_the_day_from?(stable)
    area.on_the_day_from?(stable.center)
  end

  def to_s
    name
  end
end
