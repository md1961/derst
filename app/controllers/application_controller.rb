class ApplicationController < ActionController::Base

  private

    def sire_filter_params
      params.require(:sire_filter).permit(:stability)
    end
end
