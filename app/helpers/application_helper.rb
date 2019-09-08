module ApplicationHelper

  def father_in_bloodline(horse, generation, number)
    father = horse.bloodline_father(generation, number)
    if father
      items = [link_to(father.name, edit_sire_path(father, horse_back_type: horse.class.name, horse_back_id: horse.id))]
      items << father.name_eng if father.name_eng
      items << father.inbreed_effects.join(' ') unless father.inbreed_effects.empty?
      safe_join(items, '<br>'.html_safe)
    else
      render partial: 'father_input', locals: {generation: generation, number: number}
    end
  end
end
