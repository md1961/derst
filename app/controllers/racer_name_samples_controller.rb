class RacerNameSamplesController < ApplicationController

  def index
    if params[:group_by] == 'type'
      @enum_name = params[:group_by]
      @samples_by_group = RacerNameSample.group_by('type')
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

  def update_enum_item
    sample = RacerNameSample.find(params[:id])
    item_name = params[:item_name]
    sample.send("#{item_name}!")
    flash[:sample_id] = sample.id
    enum_name = RacerNameSample.types.keys.include?(item_name) ? :type : :sex
    redirect_to racer_name_samples_path(group_by: enum_name)
  end
end
