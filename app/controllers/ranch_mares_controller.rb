class RanchMaresController < ApplicationController

  def new
    @ranch_mare = RanchMare.new(ranch_id: params[:ranch_id])
  end

  def create
    mare_name = params[:ranch_mare][:mare]
    mare = Mare.find_by(name: mare_name)
    redirect_to new_ranch_mare_path and return unless mare
    params[:ranch_mare][:mare_id] = mare.id
    racer = Racer.find_by(name: mare_name)
    params[:ranch_mare][:age] = racer.age if racer
    ranch_mare = RanchMare.new(
      params.require(:ranch_mare).permit(:ranch_id, :mare_id, :age)
    )
    ApplicationRecord.transaction do
      ranch_mare.save!
      racer&.retire!
    end
    redirect_to ranch_mare.ranch
  end

  def destroy
    ranch_mare = RanchMare.find(params[:id])
    ranch = ranch_mare.ranch
    ranch_mare.destroy
    redirect_to ranch
  end
end
