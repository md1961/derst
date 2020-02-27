class RanchSiresController < ApplicationController

  def index
    ranch = Ranch.last
    @ranch_sires = ranch.ranch_sires
  end
end
