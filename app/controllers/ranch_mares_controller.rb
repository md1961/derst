class RanchMaresController < ApplicationController

  def new
    @ranch_mare = RanchMare.new(ranch_id: params[:ranch_id])
  end

  def destroy
    ranch_mare = RanchMare.find(params[:id])
    ranch = ranch_mare.ranch
    ranch_mare.destroy
    redirect_to ranch
  end
end
