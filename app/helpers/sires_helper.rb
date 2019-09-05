module SiresHelper

  def trait_names
    %i[fee distances growth dirt temper contend health achievement stability]
  end

  def father_in_bloodline(sire, generation, number)
    father = sire.bloodline_father(generation, number)
    return nil unless father
    father.name_eng || father.name_jp
  end
end
