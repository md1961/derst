class Mare < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :lineage
end
