class Mating
  include ActiveModel::Model

  attr_accessor :mare, :sire

  @@h_inbreeds_cache = {}

  def initialize(mare, sire = nil, mare_inbreeds = nil)
    @mare = mare
    @sire = sire
    @mare_inbreeds = mare_inbreeds || @mare&.h_inbreeds
    read_cache
  end

  def nicks?
    @nicks ||= fetch_from_cache(:nicks) || Nick.good?(@sire, @mare)
  end

  def interesting?
    @interesting ||= fetch_from_cache(:interesting) \
      || [@sire, @mare].flat_map { |h| h.root_lineage_numbers }.uniq.size >= 6
  end

  def root_lineage_numbers
    @root_lineage_numbers ||= fetch_from_cache(:root_lineage_numbers) \
      || [@sire, @mare].flat_map { |h| h.root_lineage_numbers }.values_at(0, 2, 4, 6)
  end

  def h_inbreeds
    @h_inbreeds ||= \
      (@mare_inbreeds.keys & @sire.h_inbreeds.keys).yield_self { |fathers|
        fathers_father_ids = fathers.map(&:father).compact.map(&:id)
        fathers.reject { |father| fathers_father_ids.include?(father.id) }
      }.map { |father|
        [father, (@mare_inbreeds[father] + @sire.h_inbreeds[father]).sort]
      }.to_h
  end

  def score
    @score ||= fetch_from_cache(:score) \
      || h_inbreeds.reduce(0) { |value, (father, generations)|
           return -20 if (generations <=> [3, 3]) <= 0
           divisor = 1
           divisor = 2.0 if generations == [5, 5]
           value + father.inbreed_effects.map(&:score).sum / divisor
         }.round * 3 + (nicks? ? 10 : 0) + (interesting? ? 10 : 0)
  end

  def inbreed_display
    s = fetch_from_cache(:inbreed)
    return s if s

    h = h_inbreeds
    additional = ""

    thickest = h.values.sort.first
    if [[2, 2], [2, 3], [3, 3]].include?(thickest)
      h = h.reject { |_, v| v != thickest }.to_h
      additional = ", ..."
    end

    h.map { |father, generations|
      effects = ""
      effects = "(#{father.inbreed_effects.map(&:abbr).join(' ')})" \
        unless father.inbreed_effects.empty?
      "#{father.name}#{effects} #{generations.join('x')}"
    }.join(', ') + additional
  end

  def write_cache
    return unless @mare
    return if read_cache
    mare_inbreeds = @mare.h_inbreeds
    File.open(filename_for_cache, 'w') do |f|
      f.write(
        Sire.breedable.map { |sire|
          mating = Mating.new(@mare, sire, mare_inbreeds)
          [sire.id, mating.to_h]
        }.to_h.to_json
      )
    end
  end

  def clear_cache
    return unless @mare
    File.delete(filename_for_cache) if File.exists?(filename_for_cache)
    @@h_inbreeds_cache[@mare.id] = nil
  end

  def to_h
    {
      score: score,
      nicks: nicks?,
      interesting: interesting?,
      inbreed: inbreed_display,
      root_lineage_numbers: root_lineage_numbers
    }
  end

  def ==(other)
    return false unless other.is_a?(self.class)
    mare.id == other.mare.id && sire.id == other.sire.id
  end

  def to_s
    "#{mare.name} x #{sire.name}"
  end

  private

    def fetch_from_cache(name)
      @@h_inbreeds_cache.dig(@mare.id, @sire.id.to_s, name.to_s)
    end

    def read_cache
      return false unless @mare
      return false unless File.exists?(filename_for_cache)
      @@h_inbreeds_cache[@mare.id] ||= File.open(filename_for_cache) { |f|
        contents = f.read
        return false if contents.blank?
        JSON.parse(contents)
      }
      true
    end

    def filename_for_cache
      "db/cache/matings/mare-#{@mare.id}.txt"
    end
end
