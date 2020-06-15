class RanchMaresController < ApplicationController

  def show
    @ranch_mare = RanchMare.find(params[:id])
    ranch = @ranch_mare.ranch
    @ranch_mares = ranch.mares.order(ranch_mare_sort_key).map { |mare|
      ranch.ranch_mares.find_by(mare: mare)
    }
    index = @ranch_mares.index(@ranch_mare)
    @prev_mare, @next_mare = (@ranch_mares.to_a * 2).values_at(index - 1, index + 1)
  end

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
    ranch_mare.default_child_status! if ranch_mare.sire
    ApplicationRecord.transaction do
      ranch_mare.save!
      racer&.retire!
    end
    redirect_to ranch_mare.ranch
  end

  def update
    ranch_mare = RanchMare.find(params[:id])
    RanchMare.transaction do
      ranch_mare.update!(sire_id: params[:sire_id])
      ranch_mare.checking!
    end
    redirect_to ranch_mare
  end

  def delete_sire
    ranch_mare = RanchMare.find(params[:id])
    RanchMare.transaction do
      ranch_mare.update!(sire_id: nil)
      ranch_mare.default_child_status!
    end
    redirect_to ranch_mare.ranch
  end

  def destroy
    ranch_mare = RanchMare.find(params[:id])
    ranch = ranch_mare.ranch
    ranch_mare.destroy
    redirect_to ranch
  end

  def update_remark
    ranch_mare = RanchMare.find(params[:id])
    ranch_mare.update!(remark: params[:remark])
    redirect_to ranch_mare
  end
end
