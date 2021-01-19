class PostRacesController < ApplicationController

  def create
    racer = Racer.find(params[:racer_id])
    comment = params[:post_race][:comment]
    m_injury = PostRace::RE_DESCRIPTION_FOR_INJURY.match(comment)
    if m_injury && comment !~ / /
      last_week = racer.age_in_week.prev
      last_result = racer.result_in(*last_week.to_a)
      at = last_result ? (last_result.did_not_finish? ? 'レース中' : 'レース後') : '調教時'
      params[:post_race][:comment] = "#{at} #{comment}"
      comment = params[:post_race][:comment]
    end
    if comment.starts_with?('調教時')
      current_week = racer.ranch.month_week
      params[:post_race][:comment] = "#{current_week} #{comment}"
    end
    if params[:post_race][:result_id].present?
      post_race = PostRace.new(post_race_params)
      post_race.save!
    else
      old_remark = racer.remark.yield_self { |x| x.blank? ? nil : x }
      new_remark = params[:post_race][:comment]
      remark = [old_remark, new_remark].compact.join('、')
      racer.update!(remark: remark)
      racer.injure(m_injury[1]) if m_injury
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
