class Race < ApplicationRecord
  belongs_to :course
  belongs_to :grade

  enum limitation: {unrestricted: 0, female_only: 1, domestic_only: 2}
  enum weight: {age_constant: 1, constant: 2, separate: 3, handicap: 4}

  def to_s
    a = []
    a << "#{distance}#{is_turf ? nil : 'D'}#{limitation_to_s}"
    a << name
    a.compact.join(' ')
  end

  def limitation_to_s
    {female_only: '牝', domestic_only: '父'}[limitation.to_sym]
  end
end
