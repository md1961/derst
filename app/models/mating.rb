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
    Nick.good?(@sire, @mare)
  end

  def interesting?
    [@sire, @mare].flat_map { |h| h.root_lineage_numbers }.uniq.size >= 6
  end

  def h_inbreeds
    @h_inbreeds ||= \
      @mare_inbreeds.each_with_object(@sire.h_inbreeds) { |(father, generations), h|
        h[father].concat(generations) if h[father].size > 0
      }.reject { |father, generations|
        generations.size <= 1 || !@mare_inbreeds.has_key?(father)
      }.map { |father, generations|
        [father, generations.sort]
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

  def to_h
    {
      score: score,
      nicks: nicks?,
      interesting: interesting?,
      inbreed: inbreed_display
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
      return unless File.exists?(filename_for_cache)
      @@h_inbreeds_cache[@mare.id] ||= File.open(filename_for_cache) { |f|
        contents = f.read
        return if contents.blank?
        JSON.parse(contents)
      }
    end

    def filename_for_cache
      "db/cache/matings/mare-#{@mare.id}.txt"
    end
end
