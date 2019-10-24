class MareListsController < ApplicationController
  before_action :set_mare, only: %i[update delete prev next]
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
    @mares.delete(@mare)
    save_mare_list
    redirect_to mare_list_path
  end

  def destroy
    @mares.clear
    save_mare_list
    redirect_to mare_list_path
  end

  def prev
    mare = @mares.prev_of(@mare)
    redirect_to mare_path(mare.mare.id, sire_id: mare.sire.id, in_list: true)
  end

  def next
    mare = @mares.next_of(@mare)
    redirect_to mare_path(mare.mare.id, sire_id: mare.sire.id, in_list: true)
  end

  private

    def set_mare
      mare = Mare.find_by(name: params[:mare]) || Mare.find_by(id: params[:mare_id])
      sire = Sire.find_by_name( params[:sire]) || Sire.find_by(id: params[:sire_id])
      @mare = mare && sire ? Mare.new(mare, sire) : nil
    end

    def set_mare_list
      @mares = JSON.parse(session[KEY_MARE_LIST_IN_JSON] || "[]")&.map { |id| Mare.find(id) }
    end

    def save_mare_list
      session[KEY_MARE_LIST_IN_JSON] = @mares.map(&:id).to_json
    end
end
