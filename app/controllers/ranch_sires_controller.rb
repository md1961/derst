class RanchSiresController < ApplicationController
  before_action :set_ranch

  def index
    @ranch_sires = @ranch.ranch_sires.order(:year_leased)
    @html_title = '海外種牡馬'
  end

  def create
    sire = Sire.find_by_name(params[:sire])
    @ranch.ranch_sires.create!(sire: sire, year_leased: @ranch.year) if sire
    redirect_to ranch_sires_path(ranch_id: @ranch)
  end

  def destroy
    ranch_sire = RanchSire.find(params[:id])
    ranch_sire.destroy
    redirect_to ranch_sires_path(ranch_id: @ranch)
  end

  private

    def set_ranch
      @ranch = Ranch.find(params[:ranch_id])
    end
end
