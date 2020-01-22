class RacerNameSamplesController < ApplicationController

  def index
    if params[:type]
      @samples_by_type = RacerNameSample.group_by_type
    else
      @samples = RacerNameSample.order(:name)
    end
    @names = params[:names_rejected].to_s.split.join('、')
  end

  def create
    ids_created, names_rejected = [], []
    StringUtil.extract_horse_names(params[:names]).each do |name|
      sample = RacerNameSample.create!(name: name) rescue nil
      if sample
        ids_created << sample.id
      else
        names_rejected << name
      end
    end
    flash[:ids_created] = ids_created
    redirect_to racer_name_samples_path(names_rejected: names_rejected.join(' '))
  end

  def destroy
    sample = RacerNameSample.find(params[:id])
    sample.destroy
    redirect_to params[:url_back] || racer_name_samples_path
  end

  def update_type
    sample = RacerNameSample.find(params[:id])
    sample.send("#{params[:type]}!")
    flash[:sample_id] = sample.id
    redirect_to racer_name_samples_path
  end
end
