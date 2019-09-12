class Race < ApplicationRecord
  belongs_to :course
  belongs_to :grade
end
