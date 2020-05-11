class Race < ApplicationRecord
  belongs_to :course
  belongs_to :grade
  belongs_to :prize_pattern, optional: true

  enum surface: {turf: 0, dirt: 1}
  enum limitation: {unrestricted: 0, female_only: 1, domestic_only: 2, no_gelding: 3, no_female: 4}
  enum weight: {age_constant: 1, constant: 2, separate: 3, handicap: 4}

  scope :high_stake, -> { joins(:grade).where("grades.abbr IN (#{%w['Ⅰ' 'Ⅱ' 'Ⅲ'].join(',')})") }

  scope :downgrade_in_summer       , -> { where("course_id  = 2 OR  month >= 8") }
  scope :before_downgrade_in_summer, -> { where("course_id != 2 AND month <  8") }

  scope :for_age, ->(age) {
    ages = case age
           when 3
             %w[3]
           when 4
             %w[4 4U]
           else
             %w[4U 5 5U]
           end
    where(age: ages)
  }

  scope :unlimited_for, ->(racer) {
    limitations = [0]
    limitations << 1 if racer.female?
    limitations << 2 if racer.father&.domestic?
    limitations << 3 unless racer.gelding?
    limitations << 4 unless racer.female?
    where(limitation: limitations)
  }

  scope :for_racer, ->(racer, for_next_year: false, includes_overgrade: false) {
    age   = racer.age + (for_next_year ? 1 : 0)
    grade = racer.grade
    is_new_racer = grade.abbr == '新'
    month = racer.ranch.month

    grades = [grade]
    grades.concat(Grade.where(abbr: %w[Ⅲ Ⅱ Ⅰ])) if grade.abbr == 'OP'
    if age == 3 && grade.abbr == 'OP' && month <= 9
      grades = Grade.where(abbr: %w[5 OP Ⅲ Ⅱ Ⅰ])
    elsif age == 4 && racer.net_prize == 800
      grades += Grade.where(abbr: '9')
    end
    if includes_overgrade
      if age == 3 && %w[新 未].include?(grade.abbr)
        grades = Grade.where(abbr: [grade.abbr] + %w[5 OP Ⅲ Ⅱ])
      elsif (age == 3 || (age == 4 && month <= 7)) && grade.abbr == '5'
        grades = Grade.where(abbr: %w[5 9 16 OP Ⅲ Ⅱ])
      elsif (age == 3 || (age == 4 && month <= 7)) && grade.abbr == '9'
        grades = Grade.where(abbr: %w[9 16 OP Ⅲ Ⅱ])
      elsif grade.abbr == '未'
        grades = Grade.where(abbr: %w[未 5])
      elsif grade.abbr == '5'
        grades = Grade.where(abbr: %w[5 9])
      elsif grade.abbr == '9'
        grades = Grade.where(abbr: %w[9 16])
      elsif grade.abbr == '16'
        grades = Grade.where(abbr: %w[16 OP Ⅲ Ⅱ Ⅰ])
      end
    end

    if is_new_racer
      month_week = racer.ranch.month_week
      grades_from_next_month = grades + [Grade.find_by(abbr: '未')]
      grades_from_next_month.delete(Grade.find_by(abbr: '新')) unless racer.results.empty?
      for_age(age).where(grade: grades).unlimited_for(racer).in_month_of(month_week)
        .or(for_age(age).where(grade: grades_from_next_month).unlimited_for(racer)
              .in_or_after(month_week.first_of_next_month)
           )
        .or(for_age(age).where(grade: grades_from_next_month).unlimited_for(racer)
              .before(month_week)
           )
    elsif racer.downgrade_in_summer?
      before_downgrade_in_summer.for_age(age).where(grade: grades).unlimited_for(racer)
        .or(downgrade_in_summer.for_age(age).where(grade: grade.one_down).unlimited_for(racer))
    else
      for_age(age).where(grade: grades).unlimited_for(racer)
    end
  }

  scope :in_month_of, ->(month_week) {
    where("month = ?", month_week.month)
  }

  scope :before, ->(month_week) {
    month, week = month_week.to_a
    where("(month = :month AND week < :week) OR month < :month", month: month, week: week)
  }

  scope :in_or_after, ->(month_week) {
    month, week = month_week.to_a
    where("(month = :month AND week >= :week) OR month > :month", month: month, week: week)
  }

  H_LOADS_SEPARATE = open('db/loads_separate.txt') { |f|
    f.each_line.map { |line|
      [line.split.first, line.chomp.split('=').last.strip]
    }.reject { |id, loads|
      loads.empty? || loads.starts_with?('age')
    }.map { |id, loads|
      [id.to_i, loads.split('  ')]
    }.to_h
  }

  H_MINIMUM_NET_PRIZE = {
    '桜花賞'       => 1200,
    '皐月賞'       => 1200,
    'オークス'     => 1600,
    '日本ダービー' => 1600,
    '秋華賞'       => 1600,
    '菊花賞'       => 1600,
    'NHKマイルC'   => 1600,
    '宝塚記念'     => 4000,
    '有馬記念'     => 5000,
    'ジャパンC'    => 6000
  }

  def minimum_net_prize
    H_MINIMUM_NET_PRIZE[name].to_i
  end

  def not_enterable_for?(racer)
    if oversea?
      return true
    end

    return false unless H_MINIMUM_NET_PRIZE[name]
    has_not_enough_net_prize = racer.net_prize < minimum_net_prize
    return true if has_not_enough_net_prize && !H_TRIAL_RACES[name]
    has_not_enough_net_prize && !trial_race_passed?(racer)
  end

  def oversea?
    course.oversea?
  end

  def prize_for(place)
    if grade.high_stake?
      raise "Not implemented for place #{place} of high-stake" if place > 2
      return prize_pattern.prizes.find_by(place: place).amount
    end

    raise "Not implemented for place #{place}" unless place == 1

    case grade.abbr
    when '新'
      600
    when '未'
      500
    when '5'
      name ? 1050 : 750
    when '9'
      name ? (age == '4' ? 1400 : 1450) : 1100
    when '16'
      1800
    when 'OP'
      (age == '3' ? 1600 : age == '4' ? 1900 : 2400) + prize_1_increment
    else
      raise "Not supposed to reach here"
    end
  end

  def net_prize_for(place)
    return 0 if  grade.high_stake? && place != 1 && place != 2
    return 0 if !grade.high_stake? && place != 1
    prize = prize_for(place)
    prize < 1200 ? 400 : (prize / 2).floor(-1)
  end

  def load_for(racer, data_for_race_load: nil)
    if weight == 'separate' && data_for_race_load
      load_of_separate(racer, data_for_race_load)
    else
      send("load_of_#{weight}", racer)
    end
  end

  def load_plus_from_total_prize?
    %w[3 4].include?(age) && grade.abbr == 'OP'
  end

  def month_week
    MonthWeek.new(month, week)
  end

  def to_s
    a = []
    a << "#{distance_to_s} #{limitation_to_s}"
    a << name
    a << grade.name if grade.high_stake?
    a << weight_to_s
    a.compact.join(' ')
  end

  def distance_to_s
    "#{dirt? ? 'D' : nil}#{distance}"
  end

  def limitation_to_s
    {female_only: '牝', domestic_only: '父'}[limitation.to_sym]
  end

  def weight_to_s
    {constant: '定量', separate: '別定', handicap: 'ハンデ'}[weight.to_sym]
  end

  private

    H_TRIAL_RACES = {
      '桜花賞'       => %w[アネモネS チューリップ賞 ４歳牝馬特別],
      '皐月賞'       => %w[弥生賞 若葉S スプリングS],
      'オークス'     => %w[桜花賞 スイートピーS オークストライアル],
      '日本ダービー' => %w[皐月賞 青葉賞 プリンシパルS],
      '秋華賞'       => %w[クイーンS ローズS],
      '菊花賞'       => %w[セントライト記念 神戸新聞杯 京都新聞杯],
      'NHKマイルC'   => %w[NZT４歳S],
    }

    def trial_race_passed?(racer)
      trial_race_names = H_TRIAL_RACES[name]
      return true unless trial_race_names
      racer.results.includes(:race).find_all { |result|
        trial_race_names.include?(result.race.name) && result.place
      }.detect { |result|
        case result.race.grade.abbr
        when 'OP'
          result.place <= 2
        when 'Ⅲ', 'Ⅱ'
          result.place <= 3
        when 'Ⅰ'
          result.place <= 4
        else
          raise "Not supposed to reach here"
        end
      }
    end

    def prize_1_increment
      %w[アネモネS 若葉S スイートピーS プリンシパルS].include?(name) ? 450 : \
      %w[テレビ愛知OP バーデンバーデンC 札幌日経OP  ].include?(name) ? 100 : \
      0
    end

    def load_of_age_constant(racer)
      age = racer.age
      value = if age <= 4
                53
              elsif (age == 5 && month >= 7) || (age == 6 && month <= 8)
                55
              else
                54
              end
      unless racer.female?
        value += if age == 3
                   month <= 10 ? 0 : 1
                 else
                   2
                 end
      end
      value
    end

    H_LOAD_OF_CONSTANT_FOR_4U = {
    # month, week => 4, 5U
      [ 6, 1] => [53, 57],
      [ 7, 4] => [53, 58],
      [ 6, 4] => [54, 58],
      [11, 3] => [55, 57],
      [11, 4] => [55, 57],
      [12, 3] => [55, 57],
      [10, 4] => [56, 58],
      [11, 2] => [56, 58],
    }

    def load_of_constant(racer)
      return nil if oversea?

      if age == '4'
        value = grade.abbr == 'Ⅰ' || month_week.to_a == [10, 2] ? 57 : 56
      else
        value = case month_week.to_a
                when [10, 1]
                  56
                when [ 5, 2]
                  58
                when [ 2, 4]
                  racer.age == 5 ? 55 : 56
                else
                  values = H_LOAD_OF_CONSTANT_FOR_4U[month_week.to_a]
                  values[racer.age == 4 ? 0 : 1]
                end
      end
      value - (racer.female? ? 2 : 0)
    end

    # 4-52 5u-54
    def load_of_separate(racer, data_for_race_load = nil)
      return load_of_age_constant(racer) if %w[3 4].include?(age)
      base, addition = H_LOADS_SEPARATE[id]

      h_base = base.split.map { |e| e.split('-') }.map { |age, ld|
        [age.ends_with?('u') ? 'other' : age.to_i, ld.to_i]
      }.to_h
      load_base = (h_base[racer.age] || h_base['other']) - (racer.female? ? 2 : 0)

      load_base + load_addition(addition, racer, data_for_race_load = nil)
    end

    # g1-1+2 g2-1+1 (ex. age3)
    # g1-1+3 g2-1+2 g3-1+1 (ex. age3)
    # np {4-11M,5-22M,6u-33M}u 11Me +1
    # np {4-16M,5-19M,6u-22M}e +1
    def load_addition(addition, racer, data_for_race_load = nil)
      if addition.starts_with?('g')
        addition.split.reject { |e| e =~ /\A[(a]/ }.map { |e|
          e.split(/[-+]/)
        }.each do |grade, __place, add|
          n_grade = grade.sub('g', '').to_i
          to_add = false
          if data_for_race_load&.dig(:wins, n_grade) \
             || racer.results.high_stake(n_grade).where("results.age > 3").wins.count > 0
            return add.to_i
          end
        end
      elsif addition.starts_with?('np')
        elems = addition.sub('np ', '').split
        kind = elems[0][-1] == 'u' ? 'up' : 'each'
        h_net_prize = elems[0].sub(/[{}]/, '').split(',').map { |e| e.split('-') }.map { |age, np|
          [age.ends_with?('u') ? 'other' : age.to_i, np.to_i * 100]
        }.to_h
        add = elems[-1].to_i
        net_prize = data_for_race_load&.dig(:net_prize) || racer.net_prize
        if kind == 'up'
          prize_each = elems[1].to_i * 100
          prize_thres = h_net_prize[racer.age] || h_net_prize['other']
          return [net_prize - prize_thres, 0].max / prize_each * add
        else
          prize_each = h_net_prize[racer.age] || h_net_prize['other']
          return net_prize / prize_each * add
        end
      else
        raise "Illegal argument '#{addition}'"
      end
      0
    end

    def load_of_handicap(racer)
      nil
    end
end
