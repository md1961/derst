module RacersHelper

  def sire_trait_display(sire)
    return "" unless sire
    trait = sire.trait
    return "" unless trait
    "#{trait.distances}、#{trait.dirt}、#{trait.growth}"
  end

  def mare_trait_display(mare)
    return "" unless mare
    "スピード #{mare.speed}、スタミナ #{mare.stamina}"
  end

  def race_age_display(age)
    age.sub(/\A(\d)/, '\1歳').sub('U', '上')
  end

  def race_name_display(race)
    if race.name
      "#{race.name}(#{race.grade.abbr})"
    else
      "#{race_age_display(race.age)}#{race.grade}"
    end
  end

  def race_distance_display(race)
    "#{race.distance}#{race.dirt? ? 'D' : ''}"
  end

  def race_limitation_display(race)
    race.female_only? ? '牝' : race.domestic_only? ? '父' : nil
  end

  def race_display(race)
    course = race.course
    stable = @racer.stable
    transport = course.same_from?(stable) ? 'same' \
              : course.on_the_day_from?(stable) ? 'on_day' : 'remote'

    a = []
    a << race_age_display(race.age)
    a << race.grade
    a << race_distance_display(race)
    a << race_limitation_display(race)
    a << race.name
    a << race.weight_to_s

    safe_join([
      content_tag(:td, course, class: transport),
      content_tag(:td, a.join(' '), class: race.grade == @racer.grade ? '' : 'overgrade')
    ])
  end

  def race_options_for_select_for(racer)
    options_for_select(
      racer.race_candidates(includes_overgrade: true).find_all { |race|
        race.month == racer.ranch.month && race.week == racer.ranch.week
      }.map { |race|
        [race_display(race).gsub(/<[^>]?*>/, ''), race.id]
      }
    )
  end

  def result_attr_names
    %i[
      surface_condition num_racers num_frame rank_odds odds place weight
      mark_development mark_stamina mark_contend mark_temper mark_odds
      age load jockey for_bad_surface position direction comment_paddock comment_race
    ]
  end

  def result_attr_names_using_select
    %i[
      surface_condition
      mark_development mark_stamina mark_contend mark_temper mark_odds
      for_bad_surface position direction
    ]
  end

  def result_attr_display(result, name, f)
    if !f
      result.send(name)
    elsif name == :jockey
      f.select :jockey_id, options_for_select(Jockey.pluck(:name, :id))
    elsif result_attr_names_using_select.include?(name)
      f.select name, result_options_for_select_for(name)
    else
      f.text_field name, size: 2
    end
  end

  def result_options_for_select_for(name)
    case name
    when :surface_condition
      %w[良 稍 重 不]
    when :mark_development, :mark_stamina, :mark_contend, :mark_temper, :mark_odds
      %w[－ △ ▲ 〇 ◎]
    when :for_bad_surface
      %w[－ 〇 ◎]
    when :position
      %w[自在 逃げ 先行 中団 追込]
    else
      %w[任せ 逃げ 先行 中団 追込]
    end
  end
end
