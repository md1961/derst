class RanchMare < ApplicationRecord
  include Ageable

  belongs_to :ranch
  belongs_to :mare
  belongs_to :sire
end
