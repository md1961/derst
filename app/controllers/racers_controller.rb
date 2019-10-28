class RacersController < ApplicationController

  def show
    @racer = Racer.includes(:weeklies, results: :race).find(params[:id])
    @result_id_to_edit = params[:result_id_to_edit].to_i
    @post_race = PostRace.find_by(id: params[:post_race_id_to_edit])
    @includes_overgrade = params[:includes_overgrade] == 'true'
    @weeks_for_race_candidates = 12

    racers = (@racer.in_stable? ? Racer.in_stable : Racer.in_ranch).older_first
    index = racers.find_index(@racer)
    @prev_racer, @next_racer = (racers + racers).values_at(index - 1, index + 1) if index
  end

  def new
    @racer = Racer.new(params.permit(:ranch_id, :father_id, :mother_id))
    ranch_mare = @racer.ranch.ranch_mares.find_by(mare: @racer.mother, sire: @racer.father)
    @racer.age = ranch_mare ? 1 : 2
  end

  def create
    @racer = Racer.new(racer_params)
    ranch_mare = @racer.ranch.ranch_mares.find_by(mare: @racer.mother, sire: @racer.father)
    ApplicationRecord.transaction do
      @racer.save!
      ranch_mare&.update!(sire: nil)
      redirect_to @racer.ranch
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

  def create_result
    racer = Racer.find(params[:id])
    attrs = {race_id: params[:race_id], age: racer.age, condition: racer.condition}
    last_result = racer.results.last
    if last_result
      %i[
        weight mark_development mark_stamina mark_contend mark_temper mark_odds
        load jockey_id for_bad_surface position
      ].each do |name|
        attrs[name] = last_result.send(name)
      end
    end
    racer.results.create(attrs).tap { |result|
      result.set_load_from_racer_and_race!
    }
    redirect_to racer
  end

  def weekly
    racer = Racer.find(params[:id])
    condition = params[:condition]
    condition = nil if condition == '-'
    racer.condition = condition
    ranch = Ranch.find_by(id: params[:ranch_id])
    flash[:racer_id_weekly_entered] = racer.id
    redirect_to ranch || racer
  end

  def graze
    racer = Racer.find(params[:id])
    racer.graze!
    redirect_to racer.ranch
  end

  def ungraze
    racer = Racer.find(params[:id])
    racer.ungraze!
    redirect_to racer.ranch
  end

  def create_mare
    racer = Racer.find(params[:id])
    racer.create_mare
    redirect_to racer
  end

  def retire
    racer = Racer.find(params[:id])
    ranch = racer.ranch
    racer.retire!
    redirect_to ranch
  end

  private

    def racer_params
      params.require(:racer).permit(
        :ranch_id, :name, :sex, :age, :grade_given_id,
        :comment_age2, :comment_age3, :stable_id, :weight_fat, :weight_best, :weight_lean, :remark
      ).tap { |p|
        father = Sire.find_by_name( params[:father])
        mother = Mare.find_by(name: params[:mother])
        p[:father] = father if father
        p[:mother] = mother if mother
      }
    end
end
