class Mating
  include ActiveModel::Model

  attr_accessor :mare, :sire

  @@h_inbreeds_cache = {}

  def initialize(mare, sire, mare_inbreeds = nil)
    @mare = mare
    @sire = sire
    @mare_inbreeds = mare_inbreeds || @mare&.h_inbreeds
    #read_caches
  end

  def nicks?
    Nick.good?(@sire, @mare)
  end

  def interesting?
    [@sire, @mare].flat_map { |h| h.root_lineage_numbers }.uniq.size >= 6
  end

  def h_inbreeds
    @h_inbreeds ||= fetch_h_inbreeds_from_cache \
     || @mare_inbreeds.each_with_object(@sire.h_inbreeds) { |(father, generations), h|
          h[father].concat(generations) if h[father].size > 0
        }.reject { |father, generations|
          generations.size <= 1
        }.map { |father, generations|
          [father, generations.sort]
        }.to_h
  end

  def score
    h_inbreeds.reduce(0) { |value, (father, generations)|
      return -20 if (generations <=> [3, 3]) <= 0
      divisor = 1
      divisor = 2.0 if generations == [5, 5]
      value + father.inbreed_effects.map(&:score).sum / divisor
    }.round * 3 + (nicks? ? 10 : 0) + (interesting? ? 10 : 0)
  end

  def ==(other)
    return false unless other.is_a?(self.class)
    mare.id == other.mare.id && sire.id == other.sire.id
  end

  def to_s
    "#{mare.name} x #{sire.name}"
  end

  private

    def fetch_h_inbreeds_from_cache
      @@h_inbreeds_cache.dig(@mare.id, @sire.id.to_s)
    end

    def read_caches
      #return
      h_sires = {}
      @@h_inbreeds_cache[@mare.id] ||= File.open(filename_for_cache) { |f|
        JSON.parse(f.read).map { |sire_id, h_inbreeds|
          [
            sire_id.to_i,
            h_inbreeds.map { |father_name, generations|
              sire = h_sires[father_name] ||= Sire.find_by_name(father_name)
              [sire, generations]
            }.to_h
          ]
        }.to_h
      }
    end

    def filename_for_cache
      "db/cache/matings/mare-#{@mare.id}.txt"
    end

    def write_inbreed_cache
      return unless @mare
      return if File.exists?(filename_for_cache)
      mare_inbreeds = @mare.h_inbreeds
      File.open(filename_for_cache, 'w') do |f|
        f.write(
          Sire.breedable.map { |sire|
            mating = Mating.new(@mare, sire, mare_inbreeds)
            [sire.id, mating.h_inbreeds]
          }.to_h.to_json
        )
      end
    end
end
