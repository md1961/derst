module ApplicationHelper

  def father_in_bloodline(horse, generation, number)
    father = horse.bloodline_father(generation, number)
    if father
      items = [father.name_jp, father.name_eng].compact
      items << father.inbreed_effects.join(' ') unless father.inbreed_effects.empty?
      safe_join(items, '<br>'.html_safe)
    else
      render partial: 'father_input', locals: {generation: generation, number: number}
    end
  end
end
