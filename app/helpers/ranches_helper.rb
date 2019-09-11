module RanchesHelper

  def attr_display(racer, attr_name, f)
    if !f
      racer.send(attr_name)
    else
      f.number_field attr_name, step: 2
    end
  end
end
