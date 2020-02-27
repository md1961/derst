class RanchSiresController < ApplicationController

  def index
    @ranch = Ranch.last
    @ranch_sires = @ranch.ranch_sires
  end

  def create
    ranch = Ranch.find(params[:ranch_id])
    sire = Sire.find_by_name(params[:sire])
    ranch.ranch_sires.create!(sire: sire) if sire
    redirect_to ranch_sires_path
  end
end
