class SiresController < ApplicationController

  def index
    @sires = Sire.breedable.order(fee: :desc)
  end

  def show
    @sire = Sire.find(params[:id])
  end
end
