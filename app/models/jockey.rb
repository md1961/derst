class Jockey < ApplicationRecord
  belongs_to :stable, optional: true

  def to_s
    name
  end
end
