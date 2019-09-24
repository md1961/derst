class SireFilter
  include ActiveModel::Model

  attr_accessor :stability

  def conditions
    %i[stability].map { |name| condition(name) }.compact.join(' AND ')
  end

  def to_params
    {
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
