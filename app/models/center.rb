class Center < ApplicationRecord
  has_many :stables

  def area
    area_name = name == '美浦' ? 'Kanto' : 'Kansai'
    Area.find_by(name: area_name)
  end

  def short_stay?
    name == '短期'
  end

  def name_with_num_racers
    "#{name} (#{stables.flat_map(&:num_racers).sum})"
  end

  def to_s
    name
  end
end
