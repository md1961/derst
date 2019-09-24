class SireFilter
  include ActiveModel::Model

  attr_accessor :temper, :contend, :health, :stability

  def conditions
    %i[
      temper contend health stability
    ].map { |name| condition(name) }.compact.join(' AND ')
  end

  def to_params
    {
      temper: temper,
      contend: contend,
      health: health,
      stability: stability,
    }
  end

  private

    def condition(name, delimiter = /[^ABC]/)
      values = send(name)&.split(delimiter) || []
      return nil if values.empty?
      "#{name} IN ('#{values.join("', '")}')"
    end
end
