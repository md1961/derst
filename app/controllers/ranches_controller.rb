class RanchesController < ApplicationController

  KEY_SHOWS_MARES = :shows_mares_in_ranches_show

  def show
    @ranch = Ranch.last
    if params[:racer_id].to_i > 0
      flash[:racer_id_to_focus] = params[:racer_id].to_i
      redirect_to @ranch
    end

    @mares = @ranch.mares.order(ranch_mare_sort_key)

    @main_display = params[:main_display].yield_self { |x| x.blank? ? nil : x }

    @racers = @ranch.racers.active
                           .includes(:weeklies, :injury, results: {race: :grade}, target_races: :race)
                           .older_first
    if @main_display == 'all_racers'
      @racers = Racer.retired.older_first + [nil] + @racers
    elsif @main_display == 'active_inbreeds'
      @racers = @racers.where("year_birth >= ?", @ranch.year - 1).sort_by(&:ordering_for_list)
    else
      @racers = @racers.sort_by(&:ordering_for_list)
    end

    @racer_id_to_edit = params[:racer_id_to_edit].to_i

    @shows_age2_or_1 = (Racer.find_by(id: params[:racer_id_to_edit]) \
                     || Racer.find_by(id: flash[:racer_id_to_focus]))
                          .yield_self { |racer| racer && racer.age <= 2 }

    @shows_mares = session[KEY_SHOWS_MARES]

    @ready_for_next_week = params[:next_done] != 'true' \
                        && Racer.all_training_done? \
                        && Racer.none_expecting_race?
    flash[:racer_id_to_focus] = nil if @ready_for_next_week
  end

  def next_week
    ranch = Ranch.find(params[:id])
    ApplicationRecord.transaction do
      TargetRace.in_week_of(*ranch.month_week.to_a).destroy_all
      ranch.go_to_next_week
    end
    redirect_to ranch_path(ranch, next_done: true)
  end

  def mare_sort_key
    session[KEY_RANCH_MARE_SORT_KEY] = params[:key]
  end

  def toggle_mares
    @ranch = Ranch.find(params[:id])
    @mares = @ranch.mares.order(ranch_mare_sort_key)
    session[KEY_SHOWS_MARES] = params[:shows_mares] == 'true'
  end
end
