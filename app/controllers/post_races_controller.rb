class PostRacesController < ApplicationController

  def create
    racer = Racer.find(params[:racer_id])
    if params[:post_race][:result_id].present?
      post_race = PostRace.new(post_race_params)
      post_race.save!
    else
      old_remark = racer.remark.yield_self { |x| x.blank? ? nil : "" }
      new_remark = params[:post_race][:comment]
      remark = [old_remark, new_remark].compact.join('、')
      racer.update!(remark: remark)
      if m = PostRace::RE_DESCRIPTION_FOR_INJURY.match(new_remark)
        racer.injure(m[1])
      end
    end
    redirect_to racer
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
      params.require(:post_race).permit(:result_id, :comment).tap { |p|
        p[:comment]&.sub(/気味\z/, '')
      }
    end
end
