class Mare < ApplicationRecord
  include BloodlineTrackable

  self.inheritance_column = :_type_disabled

  belongs_to :father, class_name: 'Sire', optional: true
  belongs_to :lineage
  has_many :maternal_lines, class_name: 'MareMaternalLine', dependent: :destroy
  has_many :racers, foreign_key: 'mother_id'

  def to_s
    name
  end
end
