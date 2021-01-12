class Sire < ApplicationRecord
  include BloodlineTrackable

  belongs_to :father, class_name: 'Sire', optional: true
  belongs_to :root_lineage              , optional: true
  has_one :trait, class_name: 'SireTrait', dependent: :destroy
  has_many :sire_inbreed_effects, dependent: :destroy
  has_many :inbreed_effects, through: :sire_inbreed_effects
  has_many :maternal_lines, class_name: 'SireMaternalLine', dependent: :destroy
  has_many :ranch_sires

  scope :breedable, -> { joins(:trait).where.not(name_jp: nil) }

  validates :name_jp , uniqueness: true, allow_nil: true
  validates :name_eng, uniqueness: true, allow_nil: true

  def self.all_available
      Sire.joins(:ranch_sires).joins(:trait)
          .where(name_jp: nil)
          .order(fee: :desc, name_eng: :asc) \
    + Sire.breedable.includes(:trait)
          .order(fee: :desc, name_jp: :asc)
  end

  def self.english_name?(name)
    name =~ /\A[A-Za-z .'-]+\z/
  end

  def self.find_by_name(name)
    return nil unless name
    key = english_name?(name) ? :name_eng : :name_jp
    find_by(key => name)
  end

  def self.create_from_mating_of(mother, father, name)
    transaction do
      create!(name_jp: name, father: father).tap { |sire|
        sire.create_empty_trait!(father.trait.lineage)
        sire.maternal_lines.create!(generation: 2, father: mother.father)
        sire.maternal_lines.create!(generation: 3, father: mother.bloodline_father(2, 2))
        sire.maternal_lines.create!(generation: 4, father: mother.bloodline_father(3, 4))
      }
    end
  end

  def create_empty_trait!(lineage)
    create_trait!(
      lineage: lineage,
      fee: 0,
      min_distance: 0,
      max_distance: 0,
      dirt: '',
      growth: '',
      temper: '',
      contend: '',
      health: '',
      achievement: '',
      stability: ''
    )
  end

  def domestic?
    name_eng.blank?
  end

  def name
    name_jp || name_eng
  end

  def root_lineage_number
    root_lineage&.number || father&.root_lineage_number
  end

  def eql?(other)
    id == other.id
  end

  def hash
    id.hash
  end

  def to_s
    name
  end
end
