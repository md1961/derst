module SiresHelper

  def trait_names
    %i[fee distances growth dirt temper contend health achievement stability]
  end

  def father_in_bloodline(sire, generation, number)
    father = sire.bloodline_father(generation, number)
    if father
      father.name_eng || father.name_jp
    else
      render partial: 'father_input', locals: {generation: generation, number: number}
    end
  end
end
