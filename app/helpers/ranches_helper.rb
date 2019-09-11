module RanchesHelper

  def date_display(ranch)
    "#{ranch.year} 年 #{ranch.month} 月 #{ranch.week} 週"
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
