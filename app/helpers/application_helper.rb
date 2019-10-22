module ApplicationHelper

  def date_display(ranch)
    "#{ranch.year} 年 #{ranch.month} 月 #{ranch.week} 週"
  end

  def racer_name_display(racer, f = nil)
    if f && racer.stable.nil?
      f.text_field :name
    else
      mark = ''
      mark = '[父] ' if racer.father.domestic?
      "#{mark}#{racer.name}"
    end
  end

  def racer_sex_display(racer)
    {male: '牡', female: '牝', gelding: '騸'}.fetch(racer.sex&.to_sym, '-')
  end

  def monetary_display(prize)
    upper = prize >= 10000 ? "#{prize / 10000}億" : ""
    prize %= 10000
    lower = "#{upper.empty? ? prize : prize.to_s.rjust(4, '0')}万円"
    upper + lower
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
    key && t("notice.#{key}")
  end

  def button_to_next_week(ranch)
    racer = nil
    if ranch.is_a?(Racer)
      racer = ranch
      ranch = racer.ranch
    end
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

  def father_in_bloodline(horse, generation, number)
    father = horse.bloodline_father(generation, number)
    if father
      items = if @mare || @mating
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

  def race_age_display(age)
    age.sub(/\A(\d)/, '\1歳').sub('U', '上')
  end

  def race_name_display(race)
    addition = ' ' + race_addition_display(race)
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
    "#{race.dirt? ? 'D' : ''}#{race.distance}"
  end

  def race_limitation_display(race)
      race.female_only?   ? content_tag(:span, '牝', class: 'female_only') \
    : race.domestic_only? ? content_tag(:span, '父', class: 'domestic_only') : nil
  end

  def race_addition_display(race)
    [
      "",
      race_limitation_display(race),
      race.handicap? ? content_tag(:span, '[H]', class: 'handicap') : nil
    ].compact.join(' ')
  end

  def race_display(race, racer, displays_target_button: false)
    course = race.course
    stable = racer.stable
    transport = course.same_from?(stable) ? 'same_area' \
              : course.on_the_day_from?(stable) ? 'on_day' : 'remote'

    a = []
    a << race.age
    a << race_distance_display(race)
    a << race_name_display(race)
    a << "#{race.load_for(racer)}kg#{%w[3 4].include?(race.age) ? '+' : ''}" if race.separate?

    button_to_target = nil
    if displays_target_button
      is_target = racer.target?(race)
      label, path, method, clazz = race.month_week == racer.ranch.month_week \
          ? ['E', create_result_racer_path(racer, race_id: race.id)       , :post  , is_target ? 'target' : ''] \
        : is_target \
          ? [' ' ,target_race_path(racer.target_races.find_by(race: race)), :delete, 'target'] \
          : [' ' ,target_races_path(racer_id: racer.id, race_id: race.id) , :post  , ''      ]
      button_to_target = content_tag(:td, button_to(label, path, method: method, class: clazz, tabindex: -1), class: 'centered')
    end
    load_to_s = [
      race.weight_to_s || '馬齢',
      race.handicap? ? nil : "#{race.load_for(racer)}kg",
      race.separate? && %w[3 4].include?(race.age) ? "+ 獲得賞金 #{race.age == '3' ? 800 : 1200}万円毎 1kg" : nil
    ].compact.join(' ')
    safe_join([
      content_tag(:td, course, class: transport),
      button_to_target,
      content_tag(:td, safe_join(a, ' '), class: race.grade.high_stake? ? 'high_stake' \
                                               : race.grade == racer.grade ? '' : 'overgrade',
                                          title: load_to_s),
    ].compact)
  end

  def button_to_graze(racer)
    label, path, clazz = racer.in_ranch ? ['入厩', ungraze_racer_path(racer), 'in_ranch'] \
                                        : ['放牧',   graze_racer_path(racer), ''        ]
    disabled = @racer_id_to_edit.to_i > 0 \
            || label == '放牧' && Racer.num_in_ranch == (@ranch || racer.ranch).max_racers
    button_to label, path, method: :patch, disabled: disabled, class: clazz, tabindex: -1
  end

  def form_for_weekly(racer)
    return nil unless racer.in_stable?
    form_with url: weekly_racer_path(racer), local: true do
      concat select_tag :condition, options_for_select(
                                      %w[◎ ↑ ◉  ○ △ ▽ × ↓ 休 崩 太 重 -],
                                      racer.condition || racer.last_condition
                                    ),
                                    disabled: @racer_id_to_edit.to_i > 0,
                                    class: ['condition', racer.condition.nil? ? 'no_condition': ''],
                                    tabindex: racer.condition ? -1 : 0
      concat submit_tag :enter, hidden: 'hidden'
      concat hidden_field_tag :ranch_id, @ranch&.id
    end
  end
end
