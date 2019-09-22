class PostRacesController < ApplicationController

  def create
    post_race = PostRace.new(post_race_params)
    post_race.save!
    redirect_to post_race.result.racer
  end

  def edit
    post_race = PostRace.find(params[:id])
    redirect_to racer_path(post_race.result.racer, post_race_id_to_edit: post_race.id)
  end

  def update
    post_race = PostRace.find(params[:id])
    post_race.update!(post_race_params)
    redirect_to post_race.result.racer
  end

  def destroy
    post_race = PostRace.find(params[:id])
    racer = post_race.result.racer
    post_race.destroy
    redirect_to racer
  end

  private

    def post_race_params
      params.require(:post_race).permit(:result_id, :comment)
    end
end
