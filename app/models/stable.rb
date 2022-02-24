class Stable < ApplicationRecord
  belongs_to :center
  has_many :jockeys
  has_many :racers

  def num_racers
    racers.find_all(&:is_active).size
  end

  def name_with_num_racers
    "#{name} (#{num_racers}) (#{jockeys.join(' ')})"
  end

  def to_s
    "#{name}(#{center.name == '美浦' ? 'E' : 'W'})"
  end
end
