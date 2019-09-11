class Ranch < ApplicationRecord
  has_many :ranch_mares, dependent: :destroy
  has_many :mares, through: :ranch_mares
  has_many :racers
end
