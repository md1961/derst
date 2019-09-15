class Race < ApplicationRecord
  belongs_to :course
  belongs_to :grade

  enum surface: {turf: 0, dirt: 1}
  enum limitation: {unrestricted: 0, female_only: 1, domestic_only: 2}
  enum weight: {age_constant: 1, constant: 2, separate: 3, handicap: 4}

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
