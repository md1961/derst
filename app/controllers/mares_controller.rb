class MaresController < ApplicationController

  def index
    @mares = Mare.order(:price, :name)

    if v = params[:entering_bloodline]
      session[:entering_bloodline_for_mare] = v == 'true'
    end
    @entering_bloodline = session[:entering_bloodline_for_mare]
  end

  def show
  end
end
