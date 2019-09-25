class RanchMaresController < ApplicationController

  def new
    @ranch_mare = RanchMare.new(ranch_id: params[:ranch_id])
  end

  def create
    mare = Mare.find_by(name: params[:ranch_mare][:mare])
    redirect_to new_ranch_mare_path and return unless mare
    params[:ranch_mare][:mare_id] = mare.id
    ranch_mare = RanchMare.new(
      params.require(:ranch_mare).permit(:ranch_id, :mare_id, :age)
    )
    ranch_mare.save!
    redirect_to ranch_mare.ranch
  end

  def destroy
    ranch_mare = RanchMare.find(params[:id])
    ranch = ranch_mare.ranch
    ranch_mare.destroy
    redirect_to ranch
  end
end
