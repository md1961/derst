module ApplicationHelper

  def father_in_bloodline(horse, generation, number)
    father = horse.bloodline_father(generation, number)
    if father
      father.name_eng || father.name_jp
    else
      render partial: 'father_input', locals: {generation: generation, number: number}
    end
  end
end
