class Mare < ApplicationRecord
  include BloodlineTrackable

  self.inheritance_column = :_type_disabled

  belongs_to :father, class_name: 'Sire', optional: true
  belongs_to :lineage
  has_many :maternal_lines, class_name: 'MareMaternalLine', dependent: :destroy
  has_many :racers, foreign_key: 'mother_id'
  # TODO: Strictly speaking, it should be 'has_many' :ranch_mare.
  has_one :ranch_mare

  def self.in_ranch_including_future(ranch)
    (ranch.ranch_mares.map(&:mare) + Racer.active.map(&:mare).compact).sort_by(&:ordering)
  end

  def self.create_from_mating_of(mother, father, name = nil)
    name = name_by_mating_of(mother, father) unless name
    transaction do
      create!(name: name, father: father, lineage: father.trait.lineage).tap { |mare|
        mare.maternal_lines.create!(generation: 2, father: mother.father)
        mare.maternal_lines.create!(generation: 3, father: mother.bloodline_father(2, 2))
        mare.maternal_lines.create!(generation: 4, father: mother.bloodline_father(3, 4))
      }
    end
  end

  def self.find_by_mating_of(mother, father)
    find_by(name: name_by_mating_of(mother, father))
  end

  def racer_before_retire
    Racer.find_by(name: name)
  end

  def ordering
    price.yield_self { |x| x ? -x * 1000 : -racer_before_retire.net_prize }
  end

  def count_nicks
    all_matings.count(&:nicks?)
  end

  def count_interesting
    all_matings.count(&:interesting?)
  end

  def count_nicks_and_interesting
    all_matings.count { |mating| mating.nicks? && mating.interesting? }
  end

  def to_s
    name
  end

  private

    def all_matings
      @all_matings ||= Sire.breedable.map { |sire| Mating.new(self, sire) }
    end

    def self.name_by_mating_of(mother, father)
      "#{mother.name} x #{father.name}"
    end
    private_class_method :name_by_mating_of
end
