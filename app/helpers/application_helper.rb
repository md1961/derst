module ApplicationHelper

  def top_bar_class
    classes = []
    if Racer.all_training_done?
      classes << 'all_training_done'
      classes << 'expecting_race' if Racer.any_expecting_race?
    end
    classes.join(' ')
  end

  def weeks_in_ranch_class(racer)
    return 'to_be_retired' if racer.to_be_retired?
    racer.weeks_in_ranch.yield_self { |w|
      racer.injury ? 'injured' : \
            w >  4 ? 'overstay_in_ranch' : \
            w == 4 ? 'ready_to_be_stabled' \
                   : 'in_ranch'
    } + (racer.in_spa? ? ' in_spa' : '')
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
      parents = "#{racer.father} x #{racer.mother}"
      content_tag :span, "#{mark}#{racer.name}", class: 'racer_name', aria: {label: parents}
    end
  end

  def racer_sex_display(racer)
    content_tag :span, class: racer.sex do
      {male: '牡', female: '牝', gelding: '騸'}.fetch(racer.sex&.to_sym, '-')
    end
  end

  def monetary_display(prize)
    StringUtil.monetary_display(prize)
  end

  def racer_attr_display_in_td(racer, name, f, html_attrs = {})
    if f.nil? && name == :weight_fat && racer.weight_fat.blank?
      weight_fat = racer.weight_best.blank? ? nil : racer.weight_best + 10
      content_tag :td, weight_fat, class: 'weight_fat computed numeric'
    elsif name == :weights
      safe_join([
        racer_attr_display_in_td(racer, :weight_fat , f),
        racer_attr_display_in_td(racer, :weight_best, f, class: 'with_unit'),
        racer_attr_display_in_td(racer, :weight_lean, f)
      ], "\n")
    else
      classes = html_attrs[:class]&.split || []
      classes << 'default'
      classes << name.to_s << 'numeric' if name.to_s.starts_with?('weight_')
      classes << 'centered'    if %i[stable primary_jockey main_jockeys].include?(name)
      classes << 'grade_given' if name == :grade  && racer.grade_given
      classes << 'injured'     if name == :remark && racer.injury
      html_attrs.merge!(class: classes.join(' '))
      content_tag :td, racer_attr_display(racer, name, f), html_attrs
    end
  end

  def racer_attr_display(racer, name, f)
    if name == :primary_jockey
      return '－' if racer.to_be_retired?
      racer.h_num_rides_by_jockey.first&.yield_self { |jockey, num_rides|
        classes = []
        classes << 'rides_last' if jockey == racer.last_jockey
        classes << 'not_main' unless racer.main_jockeys.include?(jockey)
        %Q!<span class="#{classes.join(' ')}">#{jockey}(#{num_rides})</span>!.html_safe
      }
    elsif name == :main_jockeys
      racer.main_jockeys&.join('、')
    elsif !f && name == :remark
      if racer.injury
        racer.injury.description
      elsif @ranch
        racer.remark&.sub(/\d{4,}/, '')
      else
        racer.remark&.sub(/\d{4,}/) { |prize| "総賞金 #{monetary_display(prize)}" }
      end
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
      f.text_field name, autofocus: name.to_s.starts_with?('comment_age'),
                         data: {orig_value: racer.send(name)}
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
    [ 3, 1] => :new_birth,
    [ 3, 2] => :new_birth,
    [ 3, 3] => :new_birth,
    [ 3, 4] => :new_birth,
    [ 7, 2] => :age2_sale,
    [ 8, 2] => :age2_sale,
    [ 1, 4] => :oversea_sire,
    [12, 4] => :sell_age2
  }

  def notice(ranch)
    key = H_NOTICE[[ranch.month, ranch.week]]
    return nil unless key
    warning = ""
    if key.to_s =~ /(?:sale|birth)\z/
      vacancy = if key == :mare_sale
                  ranch.max_mares - ranch.ranch_mares.count
                else
                  ranch.max_racers - Racer.num_in_ranch
                end
      warning  = t("notice.birth", count: RanchMare.count(&:expecting?)) if key == :new_birth
      warning += t("notice.vacancy", count: vacancy)
    end
    t("notice.#{key}") + warning
  end

  def button_to_next_week(ranch)
    button_to '翌週', next_week_ranch_path(ranch), method: :patch,
                      id: 'button_to_next_week', disabled: true, tabindex: -1
  end

  def sire_trait_names
    %i[lineage fee distances growth dirt temper contend health achievement stability]
  end

  def sire_trait_human_abbr(name)
    SireTrait.human_attribute_name(name).yield_self { |x|
      return x if %i[lineage fee distances growth].include?(name)
      x.first
    }
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
      jockey load for_bad_surface position direction condition
      comment_paddock comment_race
    ]
  end

  def result_attr_display(result, name, f)
    in_paddock = result.comment_paddock.blank?
    inputting_result = result.direction.yield_self { |s| s && s.length >= 2 }
    if !f || name == :age
      return '－' if name == :place and result.place > 30
      result.send(name)
    elsif name == :jockey
      jockey = result.jockey
      clazz = Result.double_booked_jockeys.include?(jockey) ? 'double_booked_jockey' : ''
      f.select :jockey_id, options_for_select_for_jockey(jockey), {},
                            class: clazz,
                            tabindex: in_paddock || inputting_result ? -1 : 0
    elsif result_attr_names_using_select.include?(name)
      f.select name, result_options_for_select_for(name), {},
                            data: {orig_value: f.object.send(name)},
                            class: name.to_s.starts_with?('mark_') ? 'mark' : '',
                            tabindex: in_paddock || inputting_result || name == :condition ? -1 : 0
    elsif name == :num_racers
      f.number_field :num_racers, step: 1, max: 16
    elsif name == :odds
      f.number_field :odds, step: 0.1
    elsif name == :weight
      f.number_field :weight, step: 2, tabindex: inputting_result ? -1 : 0
    elsif name == :load
      race = result.race
      is_uncertain = race.handicap? || race.separate? && %w[3 4].include?(race.age)
      f.number_field :load, class: is_uncertain ? 'uncertain' : '',
                           tabindex: in_paddock || inputting_result ? -1 : 0
    else
      size = {
        comment_paddock: 20,
        comment_race:    40,
      }[name] || 2
      clazz = name == :comment_paddock ? 'allows_shortcut' \
            : name == :num_frame ? "frame_color#{frame_color(result.num_frame, result.num_racers)}" : ''
      f.text_field name, size: size, class: clazz,
        placeholder: name == :comment_race ? sprintf("%+dkg", result.weight - result.racer.weight_best) : '',
        tabindex: inputting_result && !%i[place comment_race].include?(name) ? -1 : 0
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

  def race_display(race, racer, displays_target_button: false, data_for_race_load: nil)
    course = race.course
    stable = racer.stable
    transport = if course.oversea?
                  'oversea'
                elsif racer.course_staying
                  course.same_area_with?(racer.course_staying) ? 'same_area' : 'remote'
                else
                  course.same_from?(stable) ? 'same_area' \
                    : course.on_the_day_from?(stable) ? 'on_day' : 'remote'
                end

    a = []
    a << race.age
    a << race_distance_display(race)
    a << race_name_display(race)
    if !race.handicap? && !race.oversea?
      load_for = race.load_for(racer, data_for_race_load: data_for_race_load)
      is_too_heavy = load_for >= (racer.female? ? 58 : 60)
      load_plus = race.load_plus_from_total_prize? ? '+' : ''
      a << content_tag(:span, "#{load_for}kg#{load_plus}", class: is_too_heavy ? 'load_too_heavy' : '')
    end

    button_to_target_in_td = nil
    if displays_target_button
      button_to_enter = nil
      if racer.in_stable? && race.month_week == racer.ranch.month_week
        button_to_enter = button_to(
          '^', create_result_racer_path(racer, race_id: race.id), params: {trip: false}, method: :post,
          class: ['button_to_enter', @race_ids_targeted.include?(race.id) ? 'target' : ''].join(' '),
          hidden: racer.to_be_trained?, tabindex: -1
        )
      end
      button_to_target_in_td = content_tag(:td, class: 'centered') {
        concat button_to_target(racer, race)
        concat button_to_enter
      }
    end
    clazz = race.grade.high_stake? ? 'high_stake' : race.grade <= racer.grade ? '' : 'overgrade'

    target_racers = (@target_races_by_others || []).find_all { |tr| tr.race == race }.map(&:racer)
    clazz = 'target_by_others' if target_racers.size > 0
    entered_racers = (@entered_races_by_others || []).find_all { |r| r.race == race }.map(&:racer)
    clazz = 'entry_by_others' if entered_racers.size > 0
    label_items = (target_racers + entered_racers).uniq

    clazz += ' not_enterable' if race.not_enterable_for?(racer)
    label_items << "本賞金 #{race.minimum_net_prize}万円以上" if race.minimum_net_prize > 0

    clazz += ' no_win' if race.no_win?

    safe_join([
      content_tag(:td, course, class: transport),
      button_to_target_in_td,
      content_tag(:td, safe_join(a, ' '), class: clazz, aria: {label: label_items.join(', ')}),
    ].compact)
  end

  def button_to_target(racer, race)
    is_current_week = race.month_week == racer.ranch.month_week
    path, method, clazz = racer.target?(race) \
        ? [target_race_path(racer.target_races.find_by(race: race)), :delete, 'target'] \
        : [target_races_path(racer_id: racer.id, race_id: race.id) , :post  , ''      ]
    clazz += ' no_progress'
    clazz += ' button_to_target_in_current' if is_current_week
    button_to(' ', path, method: method, remote: true,
              id: "target_for_race-#{race.id}", class: clazz,
              hidden: is_current_week && !racer.to_be_trained?, tabindex: -1)
  end

  def button_to_graze(racer)
    label, path, clazz = racer.in_ranch ? ['入厩', ungraze_racer_path(racer), 'in_ranch'] \
                                        : ['放牧',   graze_racer_path(racer), ''        ]
    ranch = @ranch || racer.ranch
    disabled = @racer_id_to_edit.to_i > 0 \
            || (label == '放牧' && Racer.num_in_ranch  == ranch.max_racers) \
            || (label == '入厩' && Racer.num_in_stable == ranch.max_stable)
    button_to label, path, method: :patch, disabled: disabled, class: clazz, tabindex: -1
  end

  def button_to_spa(racer, label_to_spa = nil)
    return nil if racer.in_ranch && !racer.in_spa?
    label_to_spa = 'へ' unless label_to_spa
    label, path, clazz = racer.in_spa? ? ['温'        , ungraze_racer_path(racer), 'in_spa'] \
                                       : [label_to_spa,     spa_racer_path(racer), ''      ]
    ranch = @ranch || racer.ranch
    disabled = @racer_id_to_edit.to_i > 0 \
            || ( racer.in_spa? && Racer.num_in_stable == ranch.max_stable) \
            || (!racer.in_spa? && Racer.num_in_spa    == ranch.max_spa)
    button_to label, path, method: :patch, disabled: disabled, class: clazz + ' button_to_spa', tabindex: -1
  end

  def form_for_weekly_condition(racer)
    return nil unless racer.in_stable?
    form_with url: condition_racer_path(racer), class: 'condition' do
      concat select_tag :condition, options_for_select(
                                      %w[◎ ↑ ◉  ○ △ ▽ × ｜ ↓ 休 崩 疲 太 重 怪 外 引 -],
                                      racer.condition || racer.default_condition
                                    ),
                                    disabled: @racer_id_to_edit.to_i > 0,
                                    id: "condition-#{racer.id}",
                                    class: ['condition', racer.condition.nil? ? 'no_condition' : ''],
                                    data: {racer_id: racer.id},
                                    autofocus: racer.id == flash[:racer_id_to_focus] \
                                                && (racer.condition.nil? || (racer.condition.present? && racer.weight.present?)),
                                    tabindex: racer.condition ? -1 : 0
      concat submit_tag :enter, hidden: 'hidden'
      concat hidden_field_tag :ranch_id, @ranch&.id, id: "ranch_id-#{racer.id}-condition"
    end
  end

  def form_for_weekly_weight(racer)
    form_with url: weight_racer_path(racer), class: 'weekly_weight' do
      concat number_field_tag :weight, racer.weight || racer.last_weight,
                                    step: 2,
                                    disabled: @racer_id_to_edit.to_i > 0,
                                    id: "weight-#{racer.id}",
                                    class: [
                                      'weight',
                                      racer.weight.nil? ? 'no_weight' : '',
                                      racer.weight_best_to_be_determined? ? 'weight_best_to_be_determined' : ''
                                    ],
                                    data: {racer_id: racer.id},
                                    autofocus: racer.id == flash[:racer_id_to_focus] && racer.condition && racer.weight.nil?,
                                    tabindex: racer.condition && !racer.weight ? 0 : -1
      concat submit_tag :enter, hidden: 'hidden'
      concat hidden_field_tag :ranch_id, @ranch&.id, id: "ranch_id-#{racer.id}-weight"
    end
  end

  def grade_abbr_of_target_races(racer, month, week)
    racer.target_races.in_week_of(month, week).map(&:race).sort_by { |race|
      race.grade.ordering
    }.last&.grade&.abbr&.sub('OP', 'オ')&.sub('16', '准')
  end

  def count_to_be_trained_display(shows_num_of_rests: false)
    count_to_be_trained = Racer.count(&:to_be_trained?)
    num_races_in_current_week = Result.num_races_in_current_week
    if count_to_be_trained.zero? && num_races_in_current_week > 0
      num_races_yet_to_come = Result.num_races_yet_to_come
      display = "#{num_races_yet_to_come} / #{num_races_in_current_week} " \
                "(#{Result.num_racers_in_race_in_current_week}/#{Racer.in_stable.count})"
      clazz = num_races_yet_to_come.zero? ? 'all_races_done' : 'not_all_races_done'
    else
      display = "#{count_to_be_trained} / #{Racer.in_stable.count}"
      clazz = count_to_be_trained.zero? ? 'all_trained' : 'not_all_trained'
    end
    display += " 休 #{Racer.in_stable.count(&:rest?)}" if shows_num_of_rests && count_to_be_trained.zero?
    content_tag :span, display, class: "count_to_be_trained #{clazz}"
  end

  def html_id_of_td_condition(age, month, week)
    sprintf("age%d-month%d-week%d", age, month, week)
  end

  def weight_transport_display(racer)
    return nil unless @racer.needs_transport?
    weight_best = racer.weight_best
    return nil unless weight_best
    "(#{weight_best + 4}～#{weight_best + 6}kg)"
  end

  def frame_color(num_frame, num_racers)
    return '' if num_frame.blank? || num_racers.blank?
    excess = num_racers - 8
    num_frame_1 = num_racers - (excess * 2)
    num_frame <= num_frame_1 ? num_frame : num_frame_1 + ((num_frame - num_frame_1) / 2.0).ceil
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

  def nicks_linenage_display(lineage, display_when_empty = '')
    lineage.nicks_lineages.yield_self { |lineages|
      lineages.empty? ? display_when_empty : lineages.map(&:name).join(', ')
    }
  end
end
