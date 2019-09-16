module RacersHelper

  def sire_trait_display(sire)
    trait = sire.trait
    return "" unless trait
    "#{trait.distances}、#{trait.dirt}、#{trait.growth}"
  end

  def mare_trait_display(mare)
    "スピード #{mare.speed}、スタミナ #{mare.stamina}"
  end
end
