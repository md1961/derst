class RanchesController < ApplicationController

  def show
    @ranch = Ranch.last
    @mares  = @ranch.mares
    @racers = @ranch.racers
    @racer_id_to_edit = params[:racer_id_to_edit].to_i
  end
end
