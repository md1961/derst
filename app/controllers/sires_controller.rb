class SiresController < ApplicationController
  before_action :set_sire      , only: %i[show edit update]
  before_action :set_horse_back, only: %i[new create edit update]

  def index
    @sire_filter = SireFilter.new(sire_filter_params)

    @sires = Sire.breedable.where(@sire_filter.conditions).order(fee: :asc, name_jp: :desc)
  end

  def show
    @name_input = {[params[:generation].to_i, params[:number].to_i] => params[:name_input]}
  end

  def new
    @sire = Sire.new(name_jp: params[:name])
  end

  def create
    @sire = Sire.new(sire_params)
    if @sire.save
      redirect_to horse_back_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @sire.update(sire_params)
      redirect_to horse_back_path
    else
      render :new
    end
  end

  private

    def set_sire
      @sire = Sire.find(params[:id])
    end

    def sire_params
      params.require(:sire).permit(:name_jp, :name_eng, :root_lineage_id).reject { |k, v|
        v.blank? && k != 'root_lineage_id'
      }.tap { |p|
        p[:father] = Sire.find_by_name(params[:father])
      }
    end

    def set_horse_back
      model = params[:horse_back_type].constantize
      @horse_back = model.find(params[:horse_back_id])
      @generation = params[:generation]
      @number     = params[:number]
    end

    def horse_back_path
      path_name = :sire_path
      send(path_name, @horse_back, name_input: @sire.name_jp, generation: @generation, number: @number)
    end
end
