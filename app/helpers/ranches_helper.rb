module RanchesHelper

  def date_display(ranch)
    "#{ranch.year} 年 #{ranch.month} 月 #{ranch.week} 週"
  end

  H_NOTICE = {
    [1, 2] => :mare_sale,
    [2, 2] => :mare_sale,
    [7, 2] => :age2_sale,
    [8, 2] => :age2_sale,
  }

  def notice(ranch)
    key = H_NOTICE[[ranch.month, ranch.week]]
    key && t(".notice.#{key}")
  end

  def racer_name_display(racer)
    mark = ''
    mark = '[父] ' if racer.father.domestic?
    "#{mark}#{racer.name}"
  end

  def racer_sex_display(racer)
    {male: '牡', female: '牝', gelding: '騸'}.fetch(racer.sex&.to_sym, '-')
  end

  def racer_attr_display(racer, attr_name, f)
    if !f
      racer.send(attr_name)
    elsif attr_name == :stable
      f.select :stable_id, [['-', nil]] + Stable.pluck(:name, :id)
    elsif attr_name.to_s.starts_with?('weight_')
      f.number_field attr_name, step: 2
    else
      f.text_field attr_name
    end
  end
end
