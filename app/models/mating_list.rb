class MatingList

  Item = Struct.new(:mating, :sex) do
    def valid?
      mating.is_a?(Mating) && [1, 2].include?(sex)
    end
  end

  def self.build_from_json(json)
    json = "[]" if json.blank?
    new(JSON.parse(json).map { |mare_id, sire_id, sex|
      mating = Mating.new(Mare.find(mare_id), Sire.find(sire_id))
      list_item = Item.new(mating, sex)
    })
  end

  def initialize(list_items)
    @list_items = list_items
  end

  def empty?
    @list_items.empty?
  end

  def size
    @list_items.size
  end

  def each(&block)
    @list_items.each(&block)
  end

  def prev_of(mating)
    return nil if @list_items.empty?
    index = @list_items.find_index { |item| item.mating == mating }
    return nil unless index
    @list_items[index - 1]
  end

  def next_of(mating)
    return nil if @list_items.empty?
    index = @list_items.find_index { |item| item.mating == mating }
    return nil unless index
    @list_items[(index + 1) % @list_items.size]
  end

  def <<(list_item)
    @list_items << list_item
    self
  end

  def delete(list_item)
    @list_items.delete(list_item)
    self
  end

  def clear
    @list_items = []
  end

  def to_json
    JSON.generate(@list_items.map { |list_item|
      mating = list_item.mating
      [mating.mare.id, mating.sire.id, list_item.sex]
    })
  end
end
