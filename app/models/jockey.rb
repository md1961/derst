class Jockey < ApplicationRecord
  belongs_to :center
  belongs_to :stable, optional: true

  def center_and_stable
    "#{center}#{center.short_stay? ? '' : stable ? ' 専属' : ''}"
  end

  def to_s
    name
  end
end
