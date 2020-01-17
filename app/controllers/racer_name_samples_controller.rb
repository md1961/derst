class RacerNameSamplesController < ApplicationController

  def index
    if params[:type]
      @samples_by_type = RacerNameSample.group_by_type
    else
      @samples = RacerNameSample.order(:name)
    end
    @new_sample = RacerNameSample.new(name: params[:name_input])
  end

  def create
    sample = RacerNameSample.new(sample_params)
    saved = sample.save
    flash[:sample_id] = sample.id if saved
    redirect_to racer_name_samples_path(saved ? {} : {name_input: sample.name})
  end

  def destroy
    sample = RacerNameSample.find(params[:id])
    sample.destroy
    redirect_to racer_name_samples_path
  end

  def update_type
    sample = RacerNameSample.find(params[:id])
    sample.send("#{params[:type]}!")
    flash[:sample_id] = sample.id
    redirect_to racer_name_samples_path
  end

  private

    def sample_params
      params.require(:racer_name_sample).permit(:name)
    end
end
