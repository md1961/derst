class SireFiltersController < ApplicationController

  def create
    path_name = params[:mare_id].to_i > 0 ? :matings_path : :sires_path
    redirect_to send(path_name, sire_filter: sire_filter_params,
                     mare_id: params[:mare_id], ranch_id: params[:ranch_id])
  end
end
