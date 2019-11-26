module RanchesHelper

  def racer_attr_names(is_active: true)
    %i[comment_age2 comment_age3 stable weight_fat weight_best weight_lean remark] \
      - (is_active ? [] : %i[weight_fat weight_lean])
  end

  def major_wins_display(racer)
    results = racer.major_wins
    return nil if results.empty?
    [
      results[0].map { |result|
        race = result.race
        "#{race.name}(#{race.distance_to_s}, #{result.age}歳)"
      }.join(', '),
      results[1]&.map { |result|
        race = result.race
        "#{race.name}(#{race.distance_to_s}, #{result.age}歳) 2着"
      }&.join(', ')
    ].compact.join(', ')
  end
end
