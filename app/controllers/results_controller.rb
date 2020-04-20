class ResultsController < ApplicationController

  def index
  end

  def list
    @results = Result.high_stake.sort_by(&:ordering)
  end

  def edit
    result = Result.find(params[:id])
    redirect_to racer_path(result.racer, result_id_to_edit: result.id)
  end

  def update
    result = Result.find(params[:id])
    racer = result.racer
    ApplicationRecord.transaction do
      result.update(result_params)
      if result.place.present?
        current_week = racer.ranch.month_week
        next_week = current_week.next
        weeks = [current_week, next_week, next_week.next]
        racer.target_races.in_weeks_of(weeks).destroy_all
        racer.target_races.undergrade(racer.grade).destroy_all
      end
    end
    redirect_to racer
  end

  def destroy
    result = Result.find(params[:id])
    result.destroy
    redirect_to result.racer
  end

  private

    def result_params
      params.require(:result).permit(
          :surface_condition, :num_racers, :num_frame, :rank_odds, :odds, :place, :weight,
          :mark_development, :mark_stamina, :mark_contend, :mark_temper, :mark_odds,
          :age, :load, :jockey_id, :for_bad_surface, :position, :direction, :condition,
          :comment_paddock, :comment_race
      ).tap { |p| p[:jockey_id] = nil if p[:jockey_id].to_i.zero? }
    end
end
