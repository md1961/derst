class RanchesController < ApplicationController

  def show
    @ranch = Ranch.last
    @mares  = @ranch.mares
    @racers = @ranch.racers
    @racer_to_edit = Racer.find_by(id: params[:racer_id_to_edit])
  end
end
