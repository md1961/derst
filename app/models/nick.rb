class Nick < ApplicationRecord
  belongs_to :lineage1, class_name: 'Lineage'
  belongs_to :lineage2, class_name: 'Lineage'

  def self.good?(sire, mare)
    sire_lineage = sire.trait.lineage
    mare_lineage = mare.lineage
       exists?(lineage1: sire_lineage, lineage2: mare_lineage) \
    || exists?(lineage1: mare_lineage, lineage2: sire_lineage)
  end
end
