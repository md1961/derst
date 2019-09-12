class Center < ApplicationRecord

  def area
    area_name = name == '美浦' ? 'Kanto' : 'Kansai'
    Area.find_by(name: area_name)
  end
end
