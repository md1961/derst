class ApplicationController < ActionController::Base

  private

    def sire_filter_params
      return {} unless params[:sire_filter]
      params.require(:sire_filter).permit(
        :temper, :contend, :health, :stability
      )
    end
end
