class TargetRacesController < ApplicationController

  def create
    target_race = TargetRace.create!(params.permit(:racer_id, :race_id))
    @racer = target_race.racer
    @race  = target_race.race
    render :switch_button_to_target
  end

  def destroy
    target_race = TargetRace.find(params[:id])
    target_race.destroy
    @racer = target_race.racer
    @race  = target_race.race
    render :switch_button_to_target
  end
end
