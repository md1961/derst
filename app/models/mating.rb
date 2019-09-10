class Mating
  attr_reader :sire, :mare

  def initialize(sire, mare, mare_inbreeds = nil)
    @sire = sire
    @mare = mare
    @mare_inbreeds = mare_inbreeds || @mare.h_inbreeds
  end

  private

    def h_inbreeds
      @h_inbreeds ||= @mare_inbreeds.each_with_object(@sire.h_inbreeds) { |(father, generations), h|
        h[father]&.concat(generations)
      }.reject { |father, generations|
        generations.size <= 1
      }.to_h
    end
end
