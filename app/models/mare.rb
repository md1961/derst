class Mare < ApplicationRecord
  include BloodlineTrackable

  self.inheritance_column = :_type_disabled

  belongs_to :father, class_name: 'Sire', optional: true
  belongs_to :lineage
  has_many :maternal_lines, class_name: 'MareMaternalLine', dependent: :destroy
  has_many :racers, foreign_key: 'mother_id'

  def self.find_by_mating_of(mother, father)
    find_by(name: name_by_mating_of(mother, father))
  end

  def self.create_from_mating_of(mother, father, name = nil)
    name = name_by_mating_of(mother, father) unless name
    Mare.transaction do
      Mare.create!(name: name, father: father, lineage: father.trait.lineage).tap { |mare|
        mare.maternal_lines.create!(generation: 2, father: mother.father)
        mare.maternal_lines.create!(generation: 3, father: mother.bloodline_father(2, 2))
        mare.maternal_lines.create!(generation: 4, father: mother.bloodline_father(3, 4))
      }
    end
  end

  def to_s
    name
  end

    def self.name_by_mating_of(mother, father)
      "#{mother.name} x #{father.name}"
    end
    private_class_method :name_by_mating_of
end
