class SireFilter
  include ActiveModel::Model

  attr_accessor :stability

  def conditions
    return "" if stability.nil? || stability !~ /[ABC]/
    return "stability = '#{stability}'" if stability.length == 1
    values = stability.split(/[^ABC]/)
    "stability IN ('#{values.join("', '")}')"
  end
end
