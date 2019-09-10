class MatingsController < ApplicationController

  def index
    @mare = Mare.find(params[:mare_id])

    @sire_filter = SireFilter.new(sire_filter_params)

    @sires = Sire.includes(:trait)
              .breedable.where(@sire_filter.conditions)
              .order(fee: :asc, name_jp: :desc)

    @entering_bloodline = false
  end

  def show
  end
end
