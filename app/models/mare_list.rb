class MareList

  Item = Struct.new(:mare, :age, :sire)

  def self.build_from_json(json)
    json = "[]" if json.blank?
    new(JSON.parse(json).map { |mare_id, age, sire_id|
      Item.new(Mare.find(mare_id), age, Sire.find_by(id: sire_id))
    })
  end

  def initialize(items)
    @items = items.sort_by { |item| -item.mare.price }
  end

  def empty?
    @items.empty?
  end

  def size
    @items.size
  end

  def each_item(&block)
    (@items + [nil] * 10).take(10).each(&block)
  end

  def add(mare, age, sire)
    @items << Item.new(mare, age, sire)
    self
  end

  def delete(mare)
    item = @items.find { |item| item.mare == mare }
    @items.delete(item)
    self
  end

  def clear
    @items = []
  end

  def to_json
    JSON.generate(@items.map { |item|
      [item.mare.id, item.age, item.sire&.id]
    })
  end
end
