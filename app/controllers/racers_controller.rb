class RacersController < ApplicationController

  def show
    @racer = Racer.find(params[:id])
    @includes_overgrade = params[:includes_overgrade] == 'true'
  end

  def new
    @racer = Racer.new(ranch_id: params[:ranch_id])
  end

  def create
    @racer = Racer.new(racer_params)
    if @racer.save
      redirect_to @racer.ranch
    else
      render :new
    end
  end

  def update
    racer = Racer.find(params[:id])
    ranch = Ranch.find(params[:ranch_id])
    if racer.update(racer_params)
      redirect_to ranch
    else
      redirect_to ranch_path(ranch, racer_id_to_edit: racer)
    end
  end

  private

    def racer_params
      params.require(:racer).permit(
        :ranch_id, :name, :sex, :age, :grade_id,
        :comment_age2, :comment_age3, :stable_id, :weight_fat, :weight_best, :weight_lean, :remark
      ).tap { |p|
        father = Sire.find_by_name( params[:father])
        mother = Mare.find_by(name: params[:mother])
        p[:father] = father if father
        p[:mother] = mother if mother
      }
    end
end
