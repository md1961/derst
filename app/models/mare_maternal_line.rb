class MareMaternalLine < ApplicationRecord
  belongs_to :mare
  belongs_to :father, class_name: 'Sire'

  validates :generation, uniqueness: {scope: :mare_id}
end
