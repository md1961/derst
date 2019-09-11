module RanchesHelper

  def date_display(ranch)
    "#{ranch.year} 年 #{ranch.month} 月 #{ranch.week} 週"
  end

  def racer_attr_display(racer, attr_name, f)
    if !f
      racer.send(attr_name)
    elsif attr_name.to_s.starts_with?('comment_age')
      f.text_field attr_name
    else
      f.number_field attr_name, step: 2
    end
  end
end
