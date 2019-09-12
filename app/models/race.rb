class Race < ApplicationRecord
  belongs_to :course
  belongs_to :grade

  enum limitation: {unrestricted: 0, female_only: 1, domestic_only: 2}
  enum weight: {age_constant: 1, constant: 2, separate: 3, handicap: 4}
end
