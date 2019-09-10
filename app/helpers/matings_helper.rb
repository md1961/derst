module MatingsHelper

  def inbreed_display(mating)
    mating.h_inbreeds.map { |f, gs| "#{f.name} #{gs.join('x')}" }.join(', ')
  end
end
