class RacerNameSamplesController < ApplicationController

  def index
    @samples = RacerNameSample.all
  end

  def create
    sample = RacerNameSample.new(sample_params)
    sample.save
    redirect_to racer_name_samples_path
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
