class Race < ApplicationRecord
  belongs_to :course
  belongs_to :grade
  belongs_to :prize_pattern, optional: true

  enum surface: {turf: 0, dirt: 1}
  enum limitation: {unrestricted: 0, female_only: 1, domestic_only: 2}
  enum weight: {age_constant: 1, constant: 2, separate: 3, handicap: 4}

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
      grades = Grade.where(abbr: %w[5 OP])
    end
    if includes_overgrade
      if age == 3 && %w[新 未].include?(grade.abbr)
        grades = Grade.where(abbr: [grade.abbr] + %w[5 OP])
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
        grades = Grade.where(abbr: %w[16 OP Ⅲ Ⅱ])
      end
    end

    if is_new_racer
      month_week = racer.ranch.month_week
      grades_from_next_month = grades + [Grade.find_by(abbr: '未')]
      grades_from_next_month.delete(Grade.find_by(abbr: '新')) unless racer.results.empty?
      for_age(age).where(grade: grades).unlimited_for(racer).in_or_after(month_week)
        .or(for_age(age).where(grade: grades_from_next_month).unlimited_for(racer)
              .in_or_after(month_week.first_of_next_month)
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
      age == '3' ? 1600 : 2400
    else
      raise "Not supposed to reach here"
    end
  end

  def net_prize_for(place)
    return 0 if  grade.high_stake? && place >= 3
    return 0 if !grade.high_stake? && place >= 2
    prize = prize_for(place)
    prize < 1200 ? 400 : (prize / 2).floor(-1)
  end

  def load_for(racer)
    send("load_of_#{weight}", racer)
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
    def load_of_separate(racer)
      return load_of_age_constant(racer) if %w[3 4].include?(age)
      base, addition = H_LOADS_SEPARATE[id]

      h_base = base.split.map { |e| e.split('-') }.map { |age, ld|
        [age.ends_with?('u') ? 'other' : age.to_i, ld.to_i]
      }.to_h
      load_base = (h_base[racer.age] || h_base['other']) - (racer.female? ? 2 : 0)

      load_base + load_addition(addition, racer)
    end

    # g1-1+2 g2-1+1 (ex. age3)
    # g1-1+3 g2-1+2 g3-1+1 (ex. age3)
    # np {4-11M,5-22M,6u-33M}u 11Me +1
    # np {4-16M,5-19M,6u-22M}e +1
    def load_addition(addition, racer)
      if addition.starts_with?('g')
        addition.split.reject { |e| e =~ /\A[(a]/ }.map { |e|
          e.split(/[-+]/)
        }.each do |grade, place, add|
          n_grade = grade.sub('g', '').to_i
          return add.to_i if racer.results.high_stake(n_grade).where(place: place).count > 0
        end
      elsif addition.starts_with?('np')
        elems = addition.sub('np ', '').split
        kind = elems[0][-1] == 'u' ? 'up' : 'each'
        h_net_prize = elems[0].sub(/[{}]/, '').split(',').map { |e| e.split('-') }.map { |age, np|
          [age.ends_with?('u') ? 'other' : age.to_i, np.to_i * 100]
        }.to_h
        add = elems[-1].to_i
        if kind == 'up'
          prize_each = elems[1].to_i * 100
          prize_thres = h_net_prize[racer.age] || h_net_prize['other']
          return (racer.net_prize - prize_thres) / prize_each * add
        else
          prize_each = h_net_prize[racer.age] || h_net_prize['other']
          return racer.net_prize / prize_each * add
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
