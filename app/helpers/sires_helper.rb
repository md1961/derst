module SiresHelper

  def trait_names
    %i[lineage fee distances growth dirt temper contend health achievement stability]
  end

  def options_for_abc
    %w[- A B C A-B B-C]
  end

  def options_for_root_linenage
    [['-', nil]] + RootLineage.order(:number).map { |root_lineage|
      ["#{root_lineage.number} #{root_lineage.name}", root_lineage.id]
    }
  end
end
