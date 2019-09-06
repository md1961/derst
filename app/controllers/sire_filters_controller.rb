class SireFiltersController < ApplicationController

  def create
    redirect_to sires_path(sire_filter: sire_filter_params)
  end
end
