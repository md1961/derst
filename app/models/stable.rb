class Stable < ApplicationRecord
  belongs_to :center
  has_many :jockeys
  has_many :racers

  def name_with_num_racers
    "#{name} (#{racers.find_all(&:is_active).size}) (#{jockeys.join(' ')})"
  end

  def to_s
    "#{name}(#{center.name == '美浦' ? 'E' : 'W'})"
  end
end
