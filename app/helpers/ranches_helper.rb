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
end
