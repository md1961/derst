class RacersController < ApplicationController

  def update
    racer = Racer.find(params[:id])
    ranch = Ranch.find(params[:ranch_id])
    if racer.update(racer_params)
      redirect_to ranch
    else
      redirect_to ranch_path(ranch, racer_id_to_edit: racer)
    end
  end

  private

    def racer_params
      params.require(:racer).permit(
        :comment_age2, :comment_age3, :weight_fat, :weight_best, :weight_lean
      )
    end
end
