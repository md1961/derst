class RanchMaresController < ApplicationController

  def new
    @ranch_mare = RanchMare.new(ranch_id: params[:ranch_id])
  end
end
