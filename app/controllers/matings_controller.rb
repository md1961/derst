class MatingsController < ApplicationController

  def index
    @mare = Mare.find(params[:mare_id])
    @sire_filter = SireFilter.new(sire_filter_params)
    @sires = Sire.includes(:trait)
              .breedable.where(@sire_filter.conditions)
              .order(fee: :asc, name_jp: :desc)
    @displays_inbreeds = params[:displays_inbreeds] == 'true'

    @ranch = Ranch.find_by(id: params[:ranch_id])
  end

  def show
    @mare = Mare.find(params[:id])
    @sire = Sire.find(params[:sire_id])
    @mating = Mating.new(@mare, @sire)
    @ranch = Ranch.find_by(id: params[:ranch_id])
    @in_list = params[:in_list] == 'true'
  end

  def new
    @mating = Mating.new(nil, nil)
  end

  def create
    mare = Mare.find_by(name: params[:mating][:mare])
    sire = Sire.find_by_name( params[:mating][:sire])
    if mare.nil? || sire.nil?
      redirect_to new_mating_path
    else
      redirect_to mating_path(id: mare, sire_id: sire.id)
    end
  end
end
