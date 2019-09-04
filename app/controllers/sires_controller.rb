class SiresController < ApplicationController

  def index
    @sires = Sire.breedable
  end
end
