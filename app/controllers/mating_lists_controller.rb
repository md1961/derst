class MatingListsController < ApplicationController
  before_action :set_mating_list

  KEY_MATING_LIST_IN_JSON = :mating_list_in_json

  def show
  end

  def update
    sire = Sire.find_by_name( params[:sire])
    mare = Mare.find_by(name: params[:mare])
    mating = Mating.new(mare, sire)
    @mating_list << mating

    save_mating_list
    redirect_to mating_list_path
  end

  def delete
    sire = Sire.find(params[:sire_id])
    mare = Mare.find(params[:mare_id])
    mating = Mating.new(mare, sire)
    @mating_list.delete(mating)

    save_mating_list
    redirect_to mating_list_path
  end

  private

    def set_mating_list
      @mating_list = MatingList.build_from_json(session[KEY_MATING_LIST_IN_JSON])
    end

    def save_mating_list
      session[KEY_MATING_LIST_IN_JSON] = @mating_list.to_json
    end
end
