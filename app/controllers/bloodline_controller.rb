class BloodlineController < ApplicationController

  def update
    model = params[:type].constantize
    horse = model.find(params[:id])
    raise "#{p horse}"
  end
end
