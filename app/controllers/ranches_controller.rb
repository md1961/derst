class RanchesController < ApplicationController

  def show
    @ranch = Ranch.last
    @mares  = @ranch.mares
    @racers = @ranch.racers
    @racer_id_to_edit = params[:racer_id_to_edit].to_i
  end

  def next_week
    ranch = Ranch.find(params[:id])
    ranch.go_to_next_week
    redirect_to ranch
  end
end
