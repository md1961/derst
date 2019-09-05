class Sire < ApplicationRecord
  belongs_to :father, class_name: 'Sire', optional: true
  belongs_to :root_lineage              , optional: true
  has_one :trait, class_name: 'SireTrait', dependent: :destroy
  has_many :sire_inbreed_effects, dependent: :destroy
  has_many :inbreed_effects, through: :sire_inbreed_effects
  has_many :sire_maternal_lines, dependent: :destroy

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

  def bloodline_father(generation, number = nil)
    case generation
    when 1
      father
    when 2
      case number
      when 1
        father.father
      else
        sire_maternal_lines.find_by(generation: 2)&.father
      end
    when 3
      case number
      when 1
        father.father&.father
      when 2
        father.bloodline_father(2)
      when 3
        bloodline_father(2)&.father
      else
        sire_maternal_lines.find_by(generation: 3)&.father
      end
    when 4
      case number
      when 1
        bloodline_father(3, 1)&.father
      when 2
        bloodline_father(2, 1)&.bloodline_father(2)
      when 3
        bloodline_father(3, 2)&.father
      when 4
        bloodline_father(2, 2)&.bloodline_father(2)
      when 5
        bloodline_father(3, 3)&.father
      when 6
        bloodline_father(3, 3)&.bloodline_father(2)
      when 7
        bloodline_father(3, 4)&.father
      else
        sire_maternal_lines.find_by(generation: 4)&.father
      end
    end
  end

  def to_s
    name
  end
end
