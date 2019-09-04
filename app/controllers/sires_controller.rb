class SiresController < ApplicationController

  def index
    @sires = Sire.breedable
  end

  def show
    @sire = Sire.find(params[:id])
  end
end
