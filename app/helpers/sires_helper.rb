module SiresHelper

  def options_for_root_linenage
    [['-', nil]] + RootLineage.order(:number).map { |root_lineage|
      ["#{root_lineage.number} #{root_lineage.name}", root_lineage.id]
    }
  end
end
