class Grade < ApplicationRecord

  scope :open_or_higher, -> { where("ordering >= 6") }

  def self.open
    @@grade_open ||= find_by(abbr: 'OP')
  end

  def high_stake?
    name.starts_with?('G')
  end

  def new_racer?
    abbr == '新'
  end

  def one_down
    self.class.where("ordering < ?", ordering).order(ordering: :desc).first
  end

  def to_s
    name
  end
end
