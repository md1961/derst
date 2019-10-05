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
    return unless racer
    return unless race&.age_constant?
    age = racer.age
    month = racer.ranch.month
    value = if age <= 4
              53
            elsif (age == 5 && month >= 6) || (age == 6 && month <= 8)
              55
            else
              54
            end
    if racer.male?
      value += if age == 3
                 month <= 10 ? 0 : 1
               else
                 2
               end
    end
    update!(load: value)
  end
end
