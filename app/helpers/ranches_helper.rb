module RanchesHelper

  def racer_attr_names(is_active: true)
    %i[comment_age2 comment_age3 stable weight_fat weight_best weight_lean remark] \
      - (is_active ? [] : %i[weight_fat weight_lean])
  end

  def racer_mating_display(racer)
    sire_trait = racer.father.trait
    mare = racer.mother
    "#{mare.speed} #{mare.stamina} x #{sire_trait.fee} #{sire_trait.stability}"
  end
end
