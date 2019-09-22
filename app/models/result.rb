class Result < ApplicationRecord
  belongs_to :racer
  belongs_to :race
  belongs_to :jockey, optional: true
  has_one :post_race
end
