class StatsController < ApplicationController

  def show
    @name = params[:name]
  end
end
