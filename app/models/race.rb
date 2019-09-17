class Race < ApplicationRecord
  belongs_to :course
  belongs_to :grade

  enum surface: {turf: 0, dirt: 1}
  enum limitation: {unrestricted: 0, female_only: 1, domestic_only: 2}
  enum weight: {age_constant: 1, constant: 2, separate: 3, handicap: 4}

  scope :for_age_and_grade, ->(age, grade, includes_overgrade: includes_overgrade) {
    ages = case age
           when 3
             %w[3]
           when 4
             %w[4 4U]
           else
             %w[4U 5 5U]
           end
    grades = [grade]
    if includes_overgrade
      if grade.abbr == '16'
        grades = Grade.where(abbr: %w[16 OP Ⅲ])
      elsif [3, 4].include?(age) && %w[5 9].include?(grade.abbr)
        grades = Grade.where(abbr: %w[5 9 16 OP Ⅲ])
      end
    end
    where(age: ages, grade: grades)
  }

  scope :for_grades, ->(grades) {
    grades = Array(grades)
    grades = Grade.open_or_higher if grades.size == 1 && grades[0].abbr == 'OP'
    where(grade: grades)
  }

  scope :unlimited_for, ->(racer) {
    limitations = [0]
    limitations << 1 if racer.female?
    limitations << 2 if racer&.father&.domestic?
    where(limitation: limitations)
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
