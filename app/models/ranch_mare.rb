class RanchMare < ApplicationRecord
  include Ageable

  belongs_to :ranch
  belongs_to :mare
end
