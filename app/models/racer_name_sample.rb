class RacerNameSample < ApplicationRecord

  validates :name, presence: true, length: {in: 2 .. 9}

  def to_s
    name
  end
end
