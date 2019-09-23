module Ageable

  def age
    return nil unless year_birth
    ranch.year - year_birth + 1
  end

  def age=(value)
    self.year_birth = value.blank? ? nil : ranch.year - value.to_i + 1
  end
end
