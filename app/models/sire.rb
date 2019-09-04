class Sire < ApplicationRecord
  belongs_to :father, class_name: 'Sire', optional: true
  belongs_to :root_lineage              , optional: true
  has_one :trait, class_name: 'SireTrait', dependent: :destroy
  has_many :sire_inbreed_effects, dependent: :destroy
  has_many :inbreed_effects, through: :sire_inbreed_effects

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
end
