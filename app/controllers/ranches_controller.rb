class RanchesController < ApplicationController

  KEY_SHOWS_MARES = :shows_mares_in_ranches_show
  KEY_SHOWS_NO_STABLE = :shows_no_stable_in_ranches_show

  def show
    @ranch = Ranch.last
    @mares = @ranch.mares

    @shows_no_stable = params[:shows_no_stable] ? params[:shows_no_stable] == 'true' \
                                                : session[KEY_SHOWS_NO_STABLE]
    session[KEY_SHOWS_NO_STABLE] = @shows_no_stable

    @racers = @ranch.racers.active.includes(:weeklies).older_first
    @racers = @racers.where.not(stable: nil) unless @shows_no_stable

    @racer_id_to_edit = params[:racer_id_to_edit].to_i
    @shows_all_racers = params[:shows_all_racers] == 'true'
    @shows_inbreeds   = params[:shows_inbreeds  ] == 'true'

    @shows_mares = params[:shows_mares] ? params[:shows_mares] == 'true' \
                                        : session[KEY_SHOWS_MARES]
    session[KEY_SHOWS_MARES] = @shows_mares

    @ready_for_next_week = params[:next_done] != 'true' \
                        && Racer.all_training_done? \
                        && Racer.none_expecting_race?
    flash[:racer_id_weekly_entered] = nil if @ready_for_next_week
  end

  def next_week
    ranch = Ranch.find(params[:id])
    ApplicationRecord.transaction do
      TargetRace.in_week_of(ranch.month_week).destroy_all
      ranch.go_to_next_week
    end
    redirect_to ranch_path(ranch, next_done: true)
  end
end
