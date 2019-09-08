class SiresController < ApplicationController
  before_action :set_sire      , only: %i[show edit]
  before_action :set_horse_back, only: %i[new create edit update]

  def index
    @sire_filter = SireFilter.new(sire_filter_params)

    @sires = Sire.breedable.where(@sire_filter.conditions).order(fee: :asc, name_jp: :desc)
  end

  def show
  end

  def new
    @sire = Sire.new(name_jp: params[:name])
  end

  def create
    @sire = Sire.new(sire_params)
    @sire.father = Sire.find_by_name(params[:father])
    if @sire.save
      redirect_to @horse_back
    else
      render :new
    end
  end

  def edit
  end

  private

    def set_sire
      @sire = Sire.find(params[:id])
    end

    def sire_params
      params.require(:sire).permit(:name_jp, :name_eng).reject { |k, v| v.blank? }
    end

    def set_horse_back
      model = params[:type].constantize
      @horse_back = model.find(params[:id])
    end
end
