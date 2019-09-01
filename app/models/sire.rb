class Sire < ApplicationRecord
  belongs_to :lineage
  belongs_to :father, class_name: 'Sire', optional: true
  belongs_to :root_lineage, optional: true
end
