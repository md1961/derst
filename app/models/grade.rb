class Grade < ApplicationRecord
  include Comparable

  scope :open_or_higher, -> { where("ordering >= 6") }

  scope :of_handicap_loads_for, ->(racer) {
    if racer.grade.nil? || racer.age == 3 || (racer.age == 4 && racer.ranch.month <= 6) \
        || racer.grade.ordering <= Grade.find_by(abbr: '5').ordering
      []
    else
      where("ordering >= ? AND abbr != 'Ⅰ'", racer.grade.ordering)
    end
  }

  def self.open
    @@grade_open ||= find_by(abbr: 'OP')
  end

  def high_stake?
    name.starts_with?('G')
  end

  def g1?
    abbr == 'Ⅰ'
  end

  def new_racer?
    abbr == '新'
  end

  def one_down
    self.class.where("ordering < ?", ordering).order(ordering: :desc).first
  end

  def <=>(other)
    return nil unless other.is_a?(self.class)
    ordering <=> other.ordering
  end

  def to_s
    name
  end
end
