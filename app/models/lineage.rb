class Lineage < ApplicationRecord

  def nicks_lineages
    Nick.where(lineage1: self).map(&:lineage2) + \
    Nick.where(lineage2: self).map(&:lineage1)
  end

  def to_s
    name
  end
end
