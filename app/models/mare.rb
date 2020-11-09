class Mare < ApplicationRecord
  extend HorseCreatable
  include BloodlineTrackable

  self.inheritance_column = :_type_disabled

  belongs_to :father, class_name: 'Sire', optional: true
  belongs_to :lineage
  has_many :maternal_lines, class_name: 'MareMaternalLine', dependent: :destroy
  has_many :racers, foreign_key: 'mother_id'
  # TODO: Strictly speaking, it should be 'has_many' :ranch_mare.
  has_one :ranch_mare

  def self.find_by_mating_of(mother, father)
    find_by(name: name_by_mating_of(mother, father))
  end

  def racer_before_retire
    Racer.find_by(name: name)
  end

  def to_s
    name
  end

    def self.name_by_mating_of(mother, father)
      "#{mother.name} x #{father.name}"
    end
    private_class_method :name_by_mating_of
end
