class HandicapLoadsController < ApplicationController

  def create
    handicap_load = HandicapLoad.create(handicap_load_params)
    redirect_to handicap_load.racer
  end

  def destroy
    handicap_load = HandicapLoad.find(params[:id])
    handicap_load.destroy
    redirect_to handicap_load.racer
  end

  private

    def handicap_load_params
      params.require(:handicap_load).permit(:racer_id, :grade_id, :load)
    end
end
