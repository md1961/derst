class RacerTrip < ApplicationRecord
  belongs_to :racer
  belongs_to :course
end
