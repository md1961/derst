class MatingListsController < ApplicationController
  before_action :set_mating_list_item, only: %i[update delete prev next]
  before_action :set_mating_list

  KEY_MATING_LIST_IN_JSON = :mating_list_in_json

  def show
    @mare = params[:mare]
    @sire = params[:sire]
    session[:ranch_id] = params[:ranch_id] if params[:ranch_id]
    @ranch = Ranch.find(session[:ranch_id])

    @html_title = '２歳馬セール'
  end

  def update
    _params = {}
    if @mating_list_item.valid?
      @mating_list << @mating_list_item
      save_mating_list
    else
      _params = params.permit(:mare, :sire)
    end
    redirect_to mating_list_path(_params)
  end

  def delete
    @mating_list.delete(@mating_list_item)
    save_mating_list
    redirect_to mating_list_path
  end

  def destroy
    @mating_list.clear
    save_mating_list
    redirect_to mating_list_path
  end

  def prev
    list_item = @mating_list.prev_of(@mating_list_item.mating)
    mating = list_item.mating
    redirect_to mating_path(mating.mare.id, sire_id: mating.sire.id, in_list: true)
  end

  def next
    list_item = @mating_list.next_of(@mating_list_item.mating)
    mating = list_item.mating
    redirect_to mating_path(mating.mare.id, sire_id: mating.sire.id, in_list: true)
  end

  private

    def set_mating_list_item
      mare = Mare.find_by(name: params[:mare]) || Mare.find_by(id: params[:mare_id])
      sire = Sire.find_by_name( params[:sire]) || Sire.find_by(id: params[:sire_id])
      mating = mare && sire ? Mating.new(mare, sire) : nil
      @mating_list_item = MatingList::Item.new(mating, params[:sex].to_i)
    end

    def set_mating_list
      @mating_list = MatingList.build_from_json(session[KEY_MATING_LIST_IN_JSON])
    end

    def save_mating_list
      session[KEY_MATING_LIST_IN_JSON] = @mating_list.to_json
    end
end
