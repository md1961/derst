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
    @ranch = Ranch.find_by(id: params[:ranch_id])
    @name_input = {[params[:generation].to_i, params[:number].to_i] => params[:name_input]}
  end

  def potentials
    ranch = Ranch.last
    @mares = Mare.in_ranch_including_future(ranch)
    @html_title = '繁殖牝馬'
  end
end
