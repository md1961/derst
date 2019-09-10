class MaresController < ApplicationController

  def index
    @mares = Mare.order(:price, :name)

    if v = params[:entering_bloodline]
      session[:entering_bloodline_for_mare] = v == 'true'
    end
    @entering_bloodline = session[:entering_bloodline_for_mare]
  end

  def show
    @mare = Mare.find(params[:id])
    @name_input = {[params[:generation].to_i, params[:number].to_i] => params[:name_input]}
  end
end
