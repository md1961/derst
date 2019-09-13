module SireFatherCache

  refine Sire do

    H_FATHERS = Sire.all.map { |s| [s.id, Sire.find_by(id: s.father_id)] }.to_h

    def father
      H_FATHERS[id]
    end
  end
end
