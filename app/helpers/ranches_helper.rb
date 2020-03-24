module RanchesHelper

  def racer_attr_names(is_active: true)
    %i[comment_age2 comment_age3 stable weight_fat weight_best weight_lean remark] \
      - (is_active ? [] : %i[weight_fat weight_lean])
  end

  def major_wins_display(racer)
    racer.major_wins.map { |results|
      results.map { |result|
        race  = result.race
        place = result.place
        place_display = place == 1 ? "" : " #{place}着"
        classes = %w[race_result]
        classes << 'g1'  if race.grade.g1?
        classes << 'win' if place == 1
        content_tag(:span, class: classes) {
          "#{race.name}(#{race.distance_to_s}, #{result.age}歳)#{place_display}"
        }
      }.join(', ').yield_self { |x| x.blank? ? nil : x }
    }.compact.join('<br>').html_safe
  end
end
