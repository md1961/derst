module RanchesHelper

  def racer_attr_names(is_active: true)
    %i[comment_age2 comment_age3 stable weight_fat weight_best weight_lean remark] \
      - (is_active ? [] : %i[weight_fat weight_lean])
  end

  def major_wins_display(racer)
    racer.major_wins.map { |results|
      results.map { |result|
        race = result.race
        place_display = result.place == 1 ? "" : " #{result.place}着"
        "#{race.name}(#{race.distance_to_s}, #{result.age}歳)#{place_display}"
      }.join(', ').yield_self { |x| x.blank? ? nil : x }
    }.compact.join('<br>').html_safe
  end

  def weeks_in_ranch_class(racer)
    return 'injured' if racer.injury
    racer.weeks_in_ranch.yield_self { |w|
      w > 4 ? 'overstay_in_ranch' : w == 4 ? 'ready_to_be_stabled' : 'in_ranch'
    }
  end
end
