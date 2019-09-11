class Jockey < ApplicationRecord
  belongs_to :stable, optional: true
end
