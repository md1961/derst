class Mating
  attr_reader :sire, :mare

  def initialize(sire, mare, mare_inbreeds = nil)
    @sire = sire
    @mare = mare
    @mare_inbreeds = mare_inbreeds || @mare.h_inbreeds
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
        }.to_h.tap { |h|
          inbreed_cache&.update_inbreeds(h)
        }
  end

  private

    def inbreed_cache
      @inbreed_cache ||= InbreedCache.find_or_create_by(mare: @mare, sire: @sire)
    end

    def fetch_h_inbreeds_from_cache
      inbreed_cache&.fetch_h_inbreeds
    end
end
