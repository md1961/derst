module RanchesHelper

  def date_display(ranch)
    "#{ranch.year} 年 #{ranch.month} 月 #{ranch.week} 週"
  end

  H_NOTICE = {
    [1, 2] => :mare_sale,
    [2, 2] => :mare_sale,
    [7, 2] => :age2_sale,
    [8, 2] => :age2_sale,
    [1, 4] => :ranch_expansion
  }

  def notice(ranch)
    key = H_NOTICE[[ranch.month, ranch.week]]
    key && t(".notice.#{key}")
  end

  def racer_name_display(racer, f)
    if f && racer.stable.nil?
      f.text_field :name
    else
      mark = ''
      mark = '[父] ' if racer.father.domestic?
      "#{mark}#{racer.name}"
    end
  end

  def racer_sex_display(racer)
    {male: '牡', female: '牝', gelding: '騸'}.fetch(racer.sex&.to_sym, '-')
  end

  def racer_attr_display(racer, name, f)
    if !f || (!racer.stable && name == :grade) \
          || (racer.stable && name.to_s.starts_with?('comment_')) \
          || (racer.age != 2 && name == :comment_age2) \
          || (racer.age != 3 && name == :comment_age3) \
          || ((!racer.results.empty? || racer.age < 3) && name == :stable) \
          || (!racer.stable && name.to_s.starts_with?('weight_'))
      racer.send(name)
    elsif name == :grade
      f.select :grade_id, [['-', nil]] + Grade.where("name NOT LIKE 'G%'").pluck(:name, :id),
                  {}, autofocus: true
    elsif name == :stable
      f.select :stable_id, [['-', nil]] + Stable.pluck(:name, :id)
    elsif name.to_s.starts_with?('weight_')
      f.number_field name, step: 2
    else
      f.text_field name
    end
  end
end
