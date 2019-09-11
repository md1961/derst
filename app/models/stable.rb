class Stable < ApplicationRecord
  belongs_to :center
  has_many :jockeys

  def to_s
    name
  end
end
