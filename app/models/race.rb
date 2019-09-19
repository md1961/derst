class Race < ApplicationRecord
  belongs_to :course
  belongs_to :grade

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
    limitations << 2 if racer&.father&.domestic?
    where(limitation: limitations)
  }

  scope :for_racer, ->(racer, for_next_year: false, includes_overgrade: false) {
    age   = racer.age + (for_next_year ? 1 : 0)
    grade = racer.grade
    month = racer.ranch.month

    grades = [grade]
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

    if racer.downgrade_in_summer?
      before_downgrade_in_summer.for_age(age).where(grade: grades).unlimited_for(racer)
        .or(downgrade_in_summer.for_age(age).where(grade: grade.one_down).unlimited_for(racer))
    else
      for_age(age).where(grade: grades).unlimited_for(racer)
    end
  }

  scope :before, ->(month, week) {
    where("(month = :month AND week < :week) OR month < :month", month: month, week: week)
  }

  scope :in_or_after, ->(month, week) {
    where("(month = :month AND week >= :week) OR month > :month", month: month, week: week)
  }

  def to_s
    a = []
    a << "#{distance}#{dirt? ? 'D' : nil}#{limitation_to_s}"
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
