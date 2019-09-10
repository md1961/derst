class Nick < ApplicationRecord
  belongs_to :lineage1, class_name: 'Lineage'
  belongs_to :lineage2, class_name: 'Lineage'
end
