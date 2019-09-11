class Racer < ApplicationRecord
  belongs_to :ranch
  belongs_to :stable, optional: true
end
