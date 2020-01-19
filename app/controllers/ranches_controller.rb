class RanchesController < ApplicationController

  KEY_SHOWS_MARES = :shows_mares_in_ranches_show
  KEY_SHOWS_NO_STABLE = :shows_no_stable_in_ranches_show

  def show
    @ranch = Ranch.last

    @mares = @ranch.mares.order(ranch_mare_sort_key)

    @shows_no_stable = params[:shows_no_stable] ? params[:shows_no_stable] == 'true' \
                                                : session[KEY_SHOWS_NO_STABLE]
    session[KEY_SHOWS_NO_STABLE] = @shows_no_stable

    @main_display = params[:main_display].yield_self { |x| x.blank? ? nil : x }

    @racers = @ranch.racers.active.includes(:weeklies).older_first
    if @main_display == 'all_racers'
      @racers = Racer.retired.older_first + [nil] + @racers
    elsif @main_display == 'active_inbreeds'
      @racers = @racers.where("year_birth >= ?", @ranch.year - 1)
    elsif !@shows_no_stable
      @racers = @racers.where("year_birth <= ?", @ranch.year - 2)
    end

    @racer_id_to_edit = params[:racer_id_to_edit].to_i

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

  def mare_sort_key
    session[KEY_RANCH_MARE_SORT_KEY] = params[:key]
  end
end
