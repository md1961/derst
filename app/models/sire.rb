class Sire < ApplicationRecord
  belongs_to :father, class_name: 'Sire', optional: true
  belongs_to :root_lineage              , optional: true
  has_one :trait, class_name: 'SireTrait', dependent: :destroy

  def self.english_name?(name)
    name =~ /\A[A-Za-z .']+\z/
  end

  def name
    name_jp || name_eng
  end
end
