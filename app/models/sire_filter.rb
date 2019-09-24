class SireFilter
  include ActiveModel::Model

  attr_accessor :growth, :temper, :contend, :health, :stability

  def conditions
    %i[
      growth temper contend health stability
    ].map { |name| condition(name) }.compact.join(' AND ')
  end

  def to_params
    {
      growth: growth,
      temper: temper,
      contend: contend,
      health: health,
      stability: stability,
    }
  end

  private

    def condition(name)
      delimiter = name == :growth ? /[-,]/ : /[^ABC]/
      values = send(name)&.split(delimiter) || []
      return nil if values.empty?
      values << '持続' if name == :growth
      "#{name} IN ('#{values.join("', '")}')"
    end
end
