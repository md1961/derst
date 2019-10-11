class RanchesController < ApplicationController

  def show
    @ranch = Ranch.last
    @mares  = @ranch.mares
    @racers = @ranch.racers.active.older_first
    @racer_id_to_edit = params[:racer_id_to_edit].to_i
    @shows_all_racers = params[:shows_all_racers] == 'true'
  end

  def next_week
    ranch = Ranch.find(params[:id])
    TargetRace.in_week_of(ranch.month_week).destroy_all
    ranch.go_to_next_week
    redirect_to ranch
  end
end
