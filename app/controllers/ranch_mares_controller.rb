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
      params.require(:ranch_mare).permit(:ranch_id, :mare_id, :age, :sire_id)
    )
    ApplicationRecord.transaction do
      ranch_mare.save!
      racer&.retire!
    end
    redirect_to ranch_mare.ranch
  end

  def update
    ranch_mare = RanchMare.find(params[:id])
    ranch_mare.update!(sire_id: params[:sire_id])
    redirect_to matings_path(mare_id: ranch_mare.mare.id, ranch_id: ranch_mare.ranch.id)
  end

  def delete_sire
    ranch_mare = RanchMare.find(params[:id])
    ranch_mare.update!(sire_id: nil)
    redirect_to ranch_mare.ranch
  end

  def destroy
    ranch_mare = RanchMare.find(params[:id])
    ranch = ranch_mare.ranch
    ranch_mare.destroy
    redirect_to ranch
  end

  def edit_remark
    @ranch_mare = RanchMare.find(params[:id])
  end

  def update_remark
    @ranch_mare = RanchMare.find(params[:id])
    @ranch_mare.update!(remark: params[:remark])
    render :edit_remark
  end
end
