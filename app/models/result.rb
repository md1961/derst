class Result < ApplicationRecord
  belongs_to :racer
  belongs_to :race
  belongs_to :jockey, optional: true
  has_one :post_race

  def net_prize
    return 0 unless place
    race.net_prize_for(place)
  end

  def set_load_from_racer_and_race!
    value = race.load_for(racer)
    return unless value
    update!(load: value)
  end
end
