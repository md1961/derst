class Course < ApplicationRecord
  belongs_to :area

  def to_s
    name
  end
end
