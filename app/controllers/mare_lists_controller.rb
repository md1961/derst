class MareListsController < ApplicationController
  before_action :set_mare_list

  KEY_MARE_LIST_IN_JSON = :mare_list_in_json

  def show
  end

  def update
    params[:mares].each do |name|
      next if name.blank?
      mare = Mare.find_by(name: name)
      @mares << mare if mare
    end
    save_mare_list
    redirect_to mare_list_path
  end

  def delete
    mare = Mare.find(params[:mare_id])
    @mares.delete(mare)
    save_mare_list
    redirect_to mare_list_path
  end

  def destroy
    @mares.clear
    save_mare_list
    redirect_to mare_list_path
  end

  private

    def set_mare_list
      @mares = JSON.parse(session[KEY_MARE_LIST_IN_JSON] || "[]")&.map { |id| Mare.find(id) }
    end

    def save_mare_list
      session[KEY_MARE_LIST_IN_JSON] = @mares.map(&:id).to_json
    end
end
