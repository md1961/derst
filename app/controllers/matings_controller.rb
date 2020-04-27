class MatingsController < ApplicationController

  def index
    @mare = Mare.find(params[:mare_id])
    @sire_filter = SireFilter.new(sire_filter_params)
    @sires = Sire.includes(:trait)
              .breedable.where(@sire_filter.conditions)
              .order(fee: :desc, name_jp: :asc)
    @sires = Sire.joins(:ranch_sires).joins(:trait).order(fee: :desc, name_eng: :asc) + @sires
    Mating.new(@mare).write_cache

    @ranch = Ranch.find_by(id: params[:ranch_id])

    @html_title = @mare.name
  end

  def show
    @mare = Mare.find(params[:id])
    @sire = Sire.find(params[:sire_id])
    @mating = Mating.new(@mare, @sire)
    @ranch = Ranch.find_by(id: params[:ranch_id])
    @in_list = params[:in_list] == 'true'
    @mating_list = MatingList.build_from_json(session[MatingListsController::KEY_MATING_LIST_IN_JSON])
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

  def create_mare
    mother = Mare.find(params[:id])
    father = Sire.find(params[:sire_id])
    Mare.create_from_mating_of(mother, father)
    redirect_to mating_path(mother, sire_id: father)
  end

  def recache
    mare = Mare.find(params[:mare_id])
    Mating.new(mare).clear_cache
    redirect_to matings_path(mare_id: mare.id)
  end

  def update_racer_name_candidates
    mare = Mare.find(params[:mare_id])
    sire = Sire.find(params[:sire_id])
    @mating = Mating.new(mare, sire)
    @names_for_candidates = params[:names_for_candidates].split(',')
    @sex = params[:sex]
    @names_to_reject = params[:names_to_reject].split(',')
  end
end
