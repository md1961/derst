class Grade < ApplicationRecord

  def self.open
    @@grade_open ||= find_by(abbr: 'OP')
  end

  def high_stake?
    name.starts_with?('G')
  end

  def to_s
    name
  end
end
