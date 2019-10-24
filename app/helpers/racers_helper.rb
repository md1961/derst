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

  def result_attr_names
    %i[
      surface_condition num_racers num_frame rank_odds odds place weight
      mark_development mark_stamina mark_contend mark_temper mark_odds
      age load jockey for_bad_surface position direction condition
      comment_paddock comment_race
    ]
  end

  def result_attr_names_using_select
    %i[
      surface_condition
      mark_development mark_stamina mark_contend mark_temper mark_odds
      for_bad_surface position direction condition
    ]
  end

  def short_term_jockey_name_in(month)
    case month
    when 3 .. 5
      'ロバーツ'
    when 6 .. 8
      'リサ'
    when 9 .. 11
      'ムンロ'
    else
      'ペリエ'
    end
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
    jockey_short = Jockey.find_by(name: short_term_jockey_name_in(@racer.ranch.month))
    h_options['短期'] = [[jockey_short.name, jockey_short.id]]
    options = keys.map { |key| [key, h_options[key]] }
    grouped_options_for_select(options, jockey&.id, prompt: '-')
  end

  def result_attr_display(result, name, f)
    in_paddock = result.comment_paddock.blank?
    if !f || name == :age
      return '－' if name == :place and result.place > 20
      result.send(name)
    elsif name == :jockey
      f.select :jockey_id, options_for_select_for_jockey(result.jockey),
                            {}, tabindex: in_paddock ? -1 : 0
    elsif result_attr_names_using_select.include?(name)
      f.select name, result_options_for_select_for(name),
                            {}, tabindex: in_paddock ? -1 : 0
    elsif name == :weight
      f.number_field name, step: 2
    elsif name == :load
      f.number_field name, class: result.race.separate? ? 'separate' : '',
                           tabindex: in_paddock ? -1 : 0
    else
      size = {
        odds:   4,
        comment_paddock: 20,
        comment_race:    20,
      }[name] || 2
      f.text_field name, size: size
    end
  end

  def result_options_for_select_for(name)
    case name
    when :surface_condition
      %w[－ 良 稍 重 不]
    when :mark_development, :mark_stamina, :mark_contend, :mark_temper, :mark_odds
      %w[－ △ ▲ 〇 ◎]
    when :for_bad_surface
      %w[－ △ 〇 ◎]
    when :position
      %w[－ 自在 逃げ 先行 中団 追込]
    when :condition
      %w[－ ◎ ↑ ◉  ○ △ ▽]
    else
      %w[－ 任せ 逃げ 先行 中団 追込]
    end
  end
end
