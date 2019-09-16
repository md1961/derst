class RacesController < ApplicationController

  def index
    @month = (params[:month] || 1).to_i
    @races_by_course = Race.where("month = ?", @month).group_by(&:course)
  end
end
