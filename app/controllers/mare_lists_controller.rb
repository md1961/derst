class MareListsController < ApplicationController
  before_action :set_mare_list

  KEY_MARE_LIST_IN_JSON = :mare_list_in_json

  def show
  end

  def update
    params[:items].each do |item|
      next if item[:mare].blank?
      mare = Mare.find_by(name: item[:mare])
      @mare_list.add(mare, item[:age], nil) if mare
    end
    save_mare_list
    redirect_to mare_list_path
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
