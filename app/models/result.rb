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
    value = if race.grade.abbr == '新'
              53
            elsif race.grade.abbr == '未'
              if racer.female?
                53
              elsif age == 3
                54
              else
                55
              end
            elsif racer.female?
              if age <= 4
                53
              elsif age == 5 and month <= 6
                54
              else
                55
              end
            else
              if age == 3
                54
              elsif age == 4
                55
              elsif (age == 5 and month <= 6) || age >= 7
                56
              else
                57
              end
            end
    update!(load: value)
  end
end
