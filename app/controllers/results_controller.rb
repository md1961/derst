class ResultsController < ApplicationController

  def update
    result = Result.find(params[:id])
    result.update!(result_params)
    redirect_to result.racer
  end

  private

    def result_params
      params.require(:result).permit(
          :surface_condition, :num_racers, :num_frame, :rank_odds, :odds, :place, :weight,
          :mark_development, :mark_stamina, :mark_contend, :mark_temper, :mark_odds,
          :age, :load, :jockey_id, :for_bad_surface, :position, :direction,
          :comment_paddock, :comment_race
      )
    end
end
