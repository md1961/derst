class Sire < ApplicationRecord
  include BloodlineTrackable

  belongs_to :father, class_name: 'Sire', optional: true
  belongs_to :root_lineage              , optional: true
  has_one :trait, class_name: 'SireTrait', dependent: :destroy
  has_many :sire_inbreed_effects, dependent: :destroy
  has_many :inbreed_effects, through: :sire_inbreed_effects
  has_many :maternal_lines, class_name: 'SireMaternalLine', dependent: :destroy

  scope :breedable, -> { joins(:trait).where.not(name_jp: nil) }

  validates :name_jp , uniqueness: true, allow_nil: true
  validates :name_eng, uniqueness: true, allow_nil: true

  def self.english_name?(name)
    name =~ /\A[A-Za-z .'-]+\z/
  end

  def self.find_by_name(name)
    key = english_name?(name) ? :name_eng : :name_jp
    find_by(key => name)
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
