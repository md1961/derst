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
    if includes_overgrade
      if (age == 3 || (age == 4 && month <= 7)) && grade.abbr == '5'
        grades = Grade.where(abbr: %w[5 9 16 OP Ⅲ Ⅱ])
      elsif (age == 3 || (age == 4 && month <= 7)) && grade.abbr == '9'
        grades = Grade.where(abbr: %w[9 16 OP Ⅲ Ⅱ])
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
      for_age(age).where(grade: grade).unlimited_for(racer).in_or_after(month_week)
        .or(for_age(age).where(grade: Grade.find_by(abbr: '未')).unlimited_for(racer)
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
      name ? 1450 : 1100
    when '16'
      1800
    when 'OP'
      age == 3 ? 1600 : 2400
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

  def month_week
    MonthWeek.new(month, week)
  end

  def to_s
    a = []
    a << "#{dirt? ? 'D' : nil}#{distance} #{limitation_to_s}"
    a << name
    a << grade.name if grade.high_stake?
    a << weight_to_s
    a.compact.join(' ')
  end

  def limitation_to_s
    {female_only: '牝', domestic_only: '父'}[limitation.to_sym]
  end

  def weight_to_s
    {constant: '定量', separate: '別定', handicap: 'ハンデ'}[weight.to_sym]
  end
end
