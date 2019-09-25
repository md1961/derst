class MatingList

  def self.build_from_json(json)
    json = "[]" if json.blank?
    new(JSON.parse(json).map { |mare_id, sire_id|
      Mating.new(Mare.find(mare_id), Sire.find(sire_id))
    })
  end

  def initialize(matings)
    @matings = matings
  end

  def each(&block)
    @matings.each(&block)
  end

  def <<(mating)
    @matings << mating
    self
  end

  def delete(mating)
    @matings.delete(mating)
    self
  end

  def to_json
    JSON.generate(@matings.map { |mating|
      [mating.mare.id, mating.sire.id]
    })
  end
end
