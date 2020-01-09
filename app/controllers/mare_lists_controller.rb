class MareListsController < ApplicationController
  before_action :set_mare_list

  KEY_MARE_LIST_IN_JSON = :mare_list_in_json

  def show
    @mare = params[:mare]
    @sire = params[:sire]
    session[:ranch_id] = params[:ranch_id] if params[:ranch_id]
    @ranch = Ranch.find(session[:ranch_id])
  end

  def update
    mare = Mare.find_by(name: params[:mare])
    sire = Sire.find_by_name( params[:sire])
    age  = params[:age].to_i
    if @mare_list.add(mare, age, sire)
      save_mare_list
      mare = sire = nil
    end
    redirect_to mare_list_path(mare: mare&.name, sire: sire&.name)
  end

  def delete
    mare = Mare.find(params[:mare_id])
    @mare_list.delete(mare)
    save_mare_list
    redirect_to mare_list_path
  end

  def destroy
    @mare_list.clear
    save_mare_list
    redirect_to mare_list_path
  end

  private

    def set_mare_list
      @mare_list = MareList.build_from_json(session[KEY_MARE_LIST_IN_JSON])
    end

    def save_mare_list
      session[KEY_MARE_LIST_IN_JSON] = @mare_list.to_json
    end
end
