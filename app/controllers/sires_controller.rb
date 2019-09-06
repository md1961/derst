class SiresController < ApplicationController

  def index
    @sire_filter = SireFilter.new(sire_filter_params)

    @sires = Sire.breedable.where(@sire_filter.conditions).order(fee: :desc)
  end

  def show
    @sire = Sire.find(params[:id])
  end
end
