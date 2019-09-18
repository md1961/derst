class Mating
  include ActiveModel::Model

  attr_accessor :sire, :mare

  @@h_inbreeds_cache = {}

  def initialize(mare, sire, mare_inbreeds = nil)
    @mare = mare
    @sire = sire
    @mare_inbreeds = mare_inbreeds || @mare&.h_inbreeds
    read_caches
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
      return nil
      @inbreed_cache ||= InbreedCache.find_or_create_by(mare: @mare, sire: @sire)
    end

    def fetch_h_inbreeds_from_cache
      return nil
      @@h_inbreeds_cache.dig(@mare.id, @sire.id)&.fetch_h_inbreeds
    end

    def read_caches
      return
      @@h_inbreeds_cache[@mare.id] ||= InbreedCache.where(mare: @mare).map { |inbreed_cache|
        [inbreed_cache.sire.id, inbreed_cache]
      }.to_h
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
