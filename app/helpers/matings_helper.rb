module MatingsHelper

  def inbreed_display(mating)
    h_inbreeds = mating.h_inbreeds
    additional = ""

    thickest = h_inbreeds.values.sort.first
    if [[2, 2], [2, 3], [3, 3]].include?(thickest)
      h_inbreeds = h_inbreeds.reject { |_, v| v != thickest }.to_h
      additional = ", ..."
    end

    h_inbreeds.map { |father, generations|
      effects = ""
      effects = "(#{father.inbreed_effects.map(&:abbr).join(' ')})" \
        unless father.inbreed_effects.empty?
      "#{father.name}#{effects} #{generations.join('x')}"
    }.join(', ') + additional
  end
end
