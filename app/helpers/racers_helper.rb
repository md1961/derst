module RacersHelper

  def racer_attr_names
    %i[comment_age2 comment_age3 stable main_jockeys weights remark]
  end

  def sire_display(sire)
    return "" unless sire
    trait = sire.trait
    return sire.name unless trait
    safe_join([
      sire.name,
      "#{trait.fee}万円、#{trait.distances}、#{trait.dirt}、#{trait.growth}、#{trait.stability}"
    ], '<br>'.html_safe)
  end

  def mare_trait_display(mare)
    return "" if mare.nil? || mare.speed.nil?
    "スピード #{mare.speed}、スタミナ #{mare.stamina}"
  end

  def racer_with_race_display(racer)
    return racer.to_s unless racer.expecting_race?
    race = racer.expecting_race
    "#{racer} - #{race.course} #{race_name_display(race, uses_styles: false)}"
  end

  def race_options_for_select_for(racer)
    grouped_options_for_select(
      racer.race_candidates(includes_overgrade: true).find_all { |race|
        race.month_week == racer.ranch.month_week
      }.group_by(&:grade).map { |grade, races|
        [
          grade,
          races.map { |race|
            [race_display(race, racer).gsub(/<[^>]?*>/, ''), race.id]
          }
        ]
      },
      nil,
      prompt: '-'
    )
  end

  def result_attr_names_using_select
    %i[
      surface_condition
      mark_development mark_stamina mark_contend mark_temper mark_odds
      for_bad_surface position direction condition
    ]
  end

  def options_for_select_for_jockey(jockey)
    h_options = Jockey.all.group_by(&:center_and_stable).map { |cs, jockeys|
      [
        cs,
        jockeys.sort_by(&:ordering).map { |j| [j.name, j.id] }
      ]
    }.to_h
    keys = @racer.stable.center.name == '美浦' ? ['美浦 専属', '美浦', '短期', '栗東 専属', '栗東'] \
                                               : ['栗東 専属', '栗東', '短期', '美浦 専属', '美浦']
    jockey_short = Jockey.short_term_jockey_in(@racer.ranch.month)
    h_options['短期'] = [[jockey_short.name, jockey_short.id]]
    options = keys.map { |key| [key, h_options[key]] }
    grouped_options_for_select(options, jockey&.id, prompt: '-')
  end

  def result_options_for_select_for(name)
    case name
    when :surface_condition
      %w[－ 良 稍 重 不]
    when :mark_development, :mark_stamina, :mark_contend, :mark_temper, :mark_odds
      %w[－ △ ▲ 〇 ◎]
    when :for_bad_surface
      %w[－ 〇 △ ◎]
    when :position
      %w[－ 逃げ 先行 中団 追込]
    when :condition
      %w[－ ◎ ↑ ◉  ○ △ ▽]
    else
      %w[－ 任せ 逃げ 先行 中団 追込 マク]
    end
  end

  def weight_transport_display(racer)
    weight_best = racer.weight_best
    "(#{weight_best + 4}～#{weight_best + 6}kg)"
  end

  MONTHS_OF_END_OF_SHORT_TERMS = [2, 5, 8, 11]

  def end_of_short_term?(month)
    MONTHS_OF_END_OF_SHORT_TERMS.include?(month)
  end
end
