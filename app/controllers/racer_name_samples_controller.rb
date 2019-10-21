class RacerNameSamplesController < ApplicationController

  def index
    @samples = RacerNameSample.order(:name)
    @new_sample = RacerNameSample.new(name: params[:name_input])
  end

  def create
    sample = RacerNameSample.new(sample_params)
    saved = sample.save
    redirect_to racer_name_samples_path(saved ? {} : {name_input: sample.name})
  end

  def destroy
    sample = RacerNameSample.find(params[:id])
    sample.destroy
    redirect_to racer_name_samples_path
  end

  private

    def sample_params
      params.require(:racer_name_sample).permit(:name)
    end
end
