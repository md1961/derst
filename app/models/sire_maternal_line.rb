class SireMaternalLine < ApplicationRecord
  belongs_to :sire
  belongs_to :father, class_name: 'Sire'

  validates :generation, uniqueness: {scope: :sire_id}
end
