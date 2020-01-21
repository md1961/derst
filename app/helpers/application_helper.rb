module ApplicationHelper

  def top_bar_class
    classes = []
    if Racer.all_training_done?
      classes << 'all_training_done'
      classes << 'expecting_race' if Racer.any_expecting_race?
    end
    classes.join(' ')
  end

  def date_display(ranch)
    "#{ranch.year} 年 #{ranch.month} 月 #{ranch.week} 週"
  end

  def racer_name_display(racer, f = nil)
    if f && racer.results.empty?
      f.text_field :name
    else
      mark = ''
      mark = '[父] ' if racer.father.domestic?
      "#{mark}#{racer.name}"
    end
  end

  def racer_sex_display(racer)
    content_tag :span, class: racer.sex do
      {male: '牡', female: '牝', gelding: '騸'}.fetch(racer.sex&.to_sym, '-')
    end
  end

  def monetary_display(prize)
    upper = prize >= 10000 ? "#{prize / 10000}億" : ""
    prize %= 10000
    lower = "#{upper.empty? ? prize : prize.to_s.rjust(4, '0')}万円"
    upper + lower
  end

  def racer_attr_display_in_td(racer, name, f, html_attrs = {})
    if f.nil? && name == :weight_fat && racer.weight_fat.blank?
      weight_fat = racer.weight_best.blank? ? nil : racer.weight_best + 10
      content_tag :td, weight_fat, class: 'computed numeric'
    elsif name == :weights
      safe_join([
        racer_attr_display_in_td(racer, :weight_fat , f),
        racer_attr_display_in_td(racer, :weight_best, f, class: 'with_unit'),
        racer_attr_display_in_td(racer, :weight_lean, f)
      ], "\n")
    else
      classes = html_attrs[:class]&.split || []
      classes << 'default'
      classes << 'numeric'     if name.to_s.starts_with?('weight_')
      classes << 'centered'    if name == :stable || name == :main_jockeys
      classes << 'emphasized'  if name == :weight_best
      classes << 'grade_given' if name == :grade  && racer.grade_given
      classes << 'injured'     if name == :remark && racer.injury
      html_attrs.merge!(class: classes.join(' '))
      content_tag :td, racer_attr_display(racer, name, f), html_attrs
    end
  end

  def racer_attr_display(racer, name, f)
    if name == :main_jockeys
      racer.stable&.jockeys&.join('、')
    elsif name == :remark && racer.injury
      racer.injury.description
    elsif !f || name == :grade \
          || (racer.stable && name.to_s.starts_with?('comment_')) \
          || (racer.age != 2 && name == :comment_age2) \
          || (racer.age != 3 && name == :comment_age3) \
          || ((!racer.results.empty? || racer.age < 3) && name == :stable) \
          || (!racer.stable && name.to_s.starts_with?('weight_'))
      racer.send(name)
    # TODO: Remove 'elsif name == :grade' from racer_attr_display().
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
    elsif name == :weight_fat
      safe_join([
        f.number_field(:weight_fat, step: 2, autofocus: true),
        content_tag(:span, '>', class: 'fat_to_best button')
      ].compact, "\n")
    elsif name == :weight_best
      f.number_field(:weight_best, step: 2, tabindex: -1)
    elsif name == :weight_lean
      safe_join([
        content_tag(:span, '<', class: 'lean_to_best button'),
        f.number_field(:weight_lean, step: 2)
      ], "\n")
    else
      f.text_field name, autofocus: name.to_s.starts_with?('comment_age')
    end
  end

  def button_to_retire(racer)
    label, verb = racer.age <= 2 ? ['売却', '売却し'] : ['引退', '引退させ']
    button_to label, retire_racer_path(racer), method: :patch,
                        class: 'critical',
                        data: {confirm: "「#{racer.name}」を#{verb}ますか？"},
                        tabindex: -1
  end

  H_NOTICE = {
    [ 1, 2] => :mare_sale,
    [ 2, 2] => :mare_sale,
    [ 2, 4] => :new_birth,
    [ 3, 1] => :new_birth,
    [ 3, 2] => :new_birth,
    [ 3, 3] => :new_birth,
    [ 7, 2] => :age2_sale,
    [ 8, 2] => :age2_sale,
    [ 1, 4] => :ranch_expansion,
    [12, 4] => :sell_age2
  }

  def notice(ranch)
    key = H_NOTICE[[ranch.month, ranch.week]]
    return nil unless key
    warning = ""
    if key.to_s =~ /(?:sale|birth)\z/
      ranch = @ranch || @racer.ranch
      vacancy = if key == :mare_sale
                  ranch.max_mares - ranch.ranch_mares.count
                else
                  ranch.max_racers - Racer.num_in_ranch
                end
      warning = t("notice.vacancy", count: vacancy)
    end
    t("notice.#{key}") + warning
  end

  def button_to_next_week(ranch)
    button_to '翌週', next_week_ranch_path(ranch), method: :patch, id: 'button_to_next_week', tabindex: -1
  end

  def sire_trait_names
    %i[lineage fee distances growth dirt temper contend health achievement stability]
  end

  def mare_trait_names
    %i[lineage price speed stamina rating type]
  end

  def options_for_growth
    %w[- 早熟 普通 晩成 持続 早熟,普通 普通,晩成]
  end

  def options_for_abc
    %w[- A B C A-B B-C]
  end

  def father_in_bloodline(horse, generation, number, readonly = true)
    father = horse.bloodline_father(generation, number)
    if father
      items = if readonly
                [father.name_jp]
              else
                [safe_join(
                  [
                    link_to(father.name, edit_sire_path(
                      father, horse_back_type: horse.class.name, horse_back_id: horse.id
                    ), tabindex: -1),
                    link_to('x', bloodline_destroy_path(
                      type: horse.class.name, id: horse.id, generation: generation, number: number
                    ), tabindex: -1)
                  ], '&nbsp;&nbsp;'.html_safe
                )]
              end
      items << father.name_eng if father.name_eng
      items << father.inbreed_effects.join(' ') unless father.inbreed_effects.empty?

      fathers_inbreed = @mating&.h_inbreeds&.keys || []
      content_tag :div, class: fathers_inbreed.include?(father) ? 'inbreed' : '' do
        safe_join(items, '<br>'.html_safe)
      end
    else
      render partial: 'father_input', locals: {generation: generation, number: number}
    end
  end

  def result_attr_names
    %i[
      surface_condition num_racers num_frame rank_odds odds place weight
      mark_development mark_stamina mark_contend mark_temper mark_odds
      load jockey for_bad_surface position direction condition
      comment_paddock comment_race
    ]
  end

  def result_attr_display(result, name, f)
    in_paddock = result.comment_paddock.blank?
    if !f || name == :age
      return '－' if name == :place and result.place > 20
      result.send(name)
    elsif name == :jockey
      f.select :jockey_id, options_for_select_for_jockey(result.jockey), {},
                            tabindex: in_paddock ? -1 : 0
    elsif result_attr_names_using_select.include?(name)
      f.select name, result_options_for_select_for(name), {},
                            data: {orig_value: f.object.send(name)},
                            tabindex: in_paddock || name == :condition ? -1 : 0
    elsif name == :weight
      f.number_field name, step: 2
    elsif name == :load
      race = result.race
      is_uncertain = race.handicap? || race.separate? && %w[3 4].include?(race.age)
      f.number_field name, class: is_uncertain ? 'uncertain' : '',
                           tabindex: in_paddock ? -1 : 0
    else
      size = {
        odds:   4,
        comment_paddock: 20,
        comment_race:    40,
      }[name] || 2
      clazz = name == :comment_paddock ? 'allows_shortcut' \
            : name == :num_frame ? "frame_color#{frame_color(result.num_frame, result.num_racers)}" : ''
      f.text_field name, size: size, class: clazz
    end
  end

  def race_age_display(age)
    age.sub(/\A(\d)/, '\1歳').sub('U', '上')
  end

  def race_name_display(race, uses_styles: true)
    addition = ' ' + race_addition_display(race, uses_styles: uses_styles)
    name = race.abbr || race.name
    content_tag :span, class: 'race_name' do
      (name ?
        "#{name}#{addition}(#{race.grade.abbr})"
      :
        "#{race_age_display(race.age)}#{race.grade}#{addition}"
      ).html_safe
    end
  end

  def race_distance_display(race)
    content_tag :span, "#{race.dirt? ? 'D' : ''}#{race.distance}", class: race.surface
  end

  def race_limitation_display(race, uses_styles: true)
      race.female_only?   ? content_tag(:span, '牝', class: uses_styles ? 'female_only' : '') \
    : race.domestic_only? ? content_tag(:span, '父', class: uses_styles ? 'domestic_only' : '') : nil
  end

  def race_addition_display(race, uses_styles: true)
    [
      "",
      race_limitation_display(race, uses_styles: uses_styles),
      race.handicap? ? content_tag(:span, '[H]', class: uses_styles ? 'handicap' : '') : nil
    ].compact.join(' ')
  end

  def race_display(race, racer, displays_target_button: false)
    course = race.course
    stable = racer.stable
    transport = if racer.course_staying
                  course.same_area_with?(racer.course_staying) ? 'same_area' : 'remote'
                else
                  course.same_from?(stable) ? 'same_area' \
                    : course.on_the_day_from?(stable) ? 'on_day' : 'remote'
                end

    a = []
    a << race.age
    a << race_distance_display(race)
    a << race_name_display(race)
    a << "#{race.load_for(racer)}kg#{race.load_plus_from_total_prize? ? '+' : ''}" unless race.handicap?

    button_to_target = nil
    if displays_target_button
      is_target = racer.target?(race)
      label, path, method, clazz = race.month_week == racer.ranch.month_week && racer.condition \
          ? ['E', create_result_racer_path(racer, race_id: race.id)       , :post  , is_target ? 'target' : ''] \
        : is_target \
          ? [' ' ,target_race_path(racer.target_races.find_by(race: race)), :delete, 'target'] \
          : [' ' ,target_races_path(racer_id: racer.id, race_id: race.id) , :post  , ''      ]
      button_to_target = content_tag(
        :td,
        button_to(label, path, method: method, params: {trip: false}, class: clazz, tabindex: -1),
        class: 'centered'
      )
    end
    clazz = race.grade.high_stake? ? 'high_stake' : race.grade <= racer.grade ? '' : 'overgrade'

    target_racers = (@target_races_by_others || []).find_all { |tr| tr.race == race }.map(&:racer)
    clazz = 'target_by_others' if target_racers.size > 0
    entered_racers = (@entered_races_by_others || []).find_all { |r| r.race == race }.map(&:racer)
    clazz = 'entry_by_others' if entered_racers.size > 0
    other_racers = (target_racers + entered_racers).uniq

    safe_join([
      content_tag(:td, course, class: transport),
      button_to_target,
      content_tag(:td, safe_join(a, ' '), class: clazz, aria: {label: other_racers.join(', ')}),
    ].compact)
  end

  def button_to_graze(racer)
    label, path, clazz = racer.in_ranch ? ['入厩', ungraze_racer_path(racer), 'in_ranch'] \
                                        : ['放牧',   graze_racer_path(racer), ''        ]
    disabled = @racer_id_to_edit.to_i > 0 \
            || (label == '放牧' && Racer.num_in_ranch == (@ranch || racer.ranch).max_racers)
    button_to label, path, method: :patch, disabled: disabled, class: clazz, tabindex: -1
  end

  def button_to_spa(racer, label_to_spa = nil)
    return nil if racer.in_ranch && !racer.in_spa?
    label_to_spa = 'へ' unless label_to_spa
    label, path, clazz = racer.in_spa? ? ['温'        , ungraze_racer_path(racer), 'in_spa'] \
                                       : [label_to_spa,     spa_racer_path(racer), ''      ]
    disabled = @racer_id_to_edit.to_i > 0 \
            || (!racer.in_spa? && Racer.num_in_spa == (@ranch || racer.ranch).max_spa)
    button_to label, path, method: :patch, disabled: disabled, class: clazz + ' button_to_spa', tabindex: -1
  end

  def form_for_weekly(racer)
    return nil unless racer.in_stable?
    form_with url: weekly_racer_path(racer), local: true do
      concat select_tag :condition, options_for_select(
                                      %w[◎ ↑ ◉  ○ △ ▽ × ↓ 休 崩 太 重 怪 -],
                                      racer.condition || racer.default_condition
                                    ),
                                    disabled: @racer_id_to_edit.to_i > 0,
                                    id: "condition-#{racer.id}",
                                    class: ['condition', racer.condition.nil? ? 'no_condition' : ''],
                                    autofocus: racer.id == flash[:racer_id_weekly_entered],
                                    tabindex: racer.condition ? -1 : 0
      concat submit_tag :enter, hidden: 'hidden'
      concat hidden_field_tag :ranch_id, @ranch&.id, id: "ranch_id-#{racer.id}"
    end
  end

  def frame_color(num_frame, num_racers)
    return '' if num_frame.blank? || num_racers.blank?
    excess = num_racers - 8
    num_frame_1 = num_racers - (excess * 2)
    num_frame <= num_frame_1 ? num_frame : num_frame_1 + ((num_frame - num_frame_1) / 2.0).ceil
  end
end
