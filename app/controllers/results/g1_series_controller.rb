class Results::G1SeriesController < ApplicationController

  def show
    @h_results = Result.g1_series
  end
end
