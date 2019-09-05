class SireMaternalLine < ApplicationRecord
  belongs_to :sire
  belongs_to :father, class_name: 'Sire'

  validates :sire_id, uniqueness: {scope: :generation}
end
