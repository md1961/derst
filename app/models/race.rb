class Race < ApplicationRecord
  belongs_to :course
  belongs_to :grade

  enum weight: {age_constant: 1, constant: 2, separate: 3, handicap: 4}
end
