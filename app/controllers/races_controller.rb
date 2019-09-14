class RacesController < ApplicationController

  def index
    month = params[:month] || 1
    @races_by_course = Race.where("month = ?", month).group_by(&:course)
  end
end
