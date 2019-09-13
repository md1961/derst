class Stable < ApplicationRecord
  belongs_to :center
  has_many :jockeys

  def to_s
    "#{name}(#{center.name == '美浦' ? 'E' : 'W'})"
  end
end
