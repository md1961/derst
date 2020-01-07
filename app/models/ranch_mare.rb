class RanchMare < ApplicationRecord
  include Ageable

  belongs_to :ranch
  belongs_to :mare
  belongs_to :sire, optional: true

  enum child_status: {default_child_status: 0, checking: 1, expecting: 2}
end
