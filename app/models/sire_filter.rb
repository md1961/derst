class SireFilter
  include ActiveModel::Model

  attr_accessor :stability

  def conditions
    return "" if stability.nil? || stability == '-'
    "stability = '#{stability}'"
  end
end
