class TargetRacesController < ApplicationController

  def create
    TargetRace.create!(params.permit(:racer_id, :race_id))
    redirect_to Racer.find(params[:racer_id])
  end

  def destroy
    target_race = TargetRace.find(params[:id])
    racer = target_race.racer
    target_race.destroy
    redirect_to racer
  end
end
