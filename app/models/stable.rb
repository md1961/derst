class Stable < ApplicationRecord
  belongs_to :center
  has_many :jockeys
end
