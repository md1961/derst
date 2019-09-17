class Race < ApplicationRecord
  belongs_to :course
  belongs_to :grade

  enum surface: {turf: 0, dirt: 1}
  enum limitation: {unrestricted: 0, female_only: 1, domestic_only: 2}
  enum weight: {age_constant: 1, constant: 2, separate: 3, handicap: 4}

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

  scope :for_racer, ->(racer, for_next_year: false, includes_overgrade: includes_overgrade) {
    age   = racer.age + (for_next_year ? 1 : 0)
    grade = racer.grade

    grades = [grade]
    if includes_overgrade
      if grade.abbr == '16'
        grades = Grade.where(abbr: %w[16 OP Ⅲ])
      elsif [3, 4].include?(age) && %w[5 9].include?(grade.abbr)
        grades = Grade.where(abbr: %w[5 9 16 OP Ⅲ])
      end
    end

    for_age(age).where(grade: grades).unlimited_for(racer)
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
