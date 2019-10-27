module RanchesHelper

  def racer_attr_names(is_active: true)
    %i[comment_age2 comment_age3 stable weight_fat weight_best weight_lean remark] \
      - (is_active ? [] : %i[weight_fat weight_lean])
  end

  def racer_attr_display_in_td(racer, name, f)
    classes = %w[default]
    classes << 'numeric'     if name.to_s.starts_with?('weight_')
    classes << 'centered'    if name == :stable
    classes << 'emphasized'  if name == :weight_best
    classes << 'grade_given' if name == :grade && racer.grade_given
    content_tag :td, racer_attr_display(racer, name, f), class: classes.join(' ')
  end

  def racer_attr_display(racer, name, f)
    if !f || (!racer.stable && name == :grade) \
          || (racer.stable && name.to_s.starts_with?('comment_')) \
          || (racer.age != 2 && name == :comment_age2) \
          || (racer.age != 3 && name == :comment_age3) \
          || ((!racer.results.empty? || racer.age < 3) && name == :stable) \
          || (!racer.stable && name.to_s.starts_with?('weight_')) \
          || (name == :grade && true)
      racer.send(name)
    elsif name == :grade
      f.select :grade_given_id, [['-', nil]] + Grade.where("name NOT LIKE 'G%'").pluck(:name, :id),
                  {}, autofocus: true
    elsif name == :stable
      options = Stable.all.group_by(&:center).map { |center, stables|
        [
          center.name,
          stables.map { |stable| [stable.name_with_num_racers, stable.id] }
        ]
      }
      f.select :stable_id, grouped_options_for_select(options, racer.stable&.id, prompt: '-')
    elsif name.to_s.starts_with?('weight_')
      safe_join([
        name == :weight_lean ? content_tag(:span, '<', class: 'lean_to_best button') : nil,
        f.number_field(name, step: 2, autofocus: name == :weight_fat),
        name == :weight_fat  ? content_tag(:span, '>', class: 'fat_to_best  button') : nil
      ].compact, "\n")
    else
      f.text_field name, autofocus: name.to_s.starts_with?('comment_age')
    end
  end

  def major_wins_display(racer)
    results = racer.major_wins
    return nil if results.empty?
    results.map { |result|
      race = result.race
      "#{race.name}(#{race.distance_to_s}, #{result.age}歳)"
    }.join(', ')
  end
end
