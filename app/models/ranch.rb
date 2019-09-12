class Ranch < ApplicationRecord
  has_many :ranch_mares, dependent: :destroy
  has_many :mares, through: :ranch_mares
  has_many :racers

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
