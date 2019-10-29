class RanchesController < ApplicationController

  def show
    @ranch = Ranch.last
    @mares  = @ranch.mares
    @racers = @ranch.racers.active.older_first
    @racer_id_to_edit = params[:racer_id_to_edit].to_i
    @shows_all_racers = params[:shows_all_racers] == 'true'
    @ready_for_next_week = params[:next_done] != 'true' \
                        && Racer.in_stable.count > 0 \
                        && Racer.all_training_done? \
                        && Racer.includes(:results).none?(&:expecting_race?)
    flash[:racer_id_weekly_entered] = nil if @ready_for_next_week
  end

  def next_week
    ranch = Ranch.find(params[:id])
    TargetRace.in_week_of(ranch.month_week).destroy_all
    ranch.go_to_next_week
    redirect_to ranch_path(ranch, next_done: true)
  end
end
