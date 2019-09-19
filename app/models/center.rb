class Center < ApplicationRecord

  def area
    area_name = name == '美浦' ? 'Kanto' : 'Kansai'
    Area.find_by(name: area_name)
  end

  def short_stay?
    name == '短期'
  end

  def to_s
    name
  end
end
