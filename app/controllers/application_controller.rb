class ApplicationController < ActionController::Base
  before_action :authenticate

  private

    HOSTNAMES_TO_REJECT = %w[namaka mimas sinope rael ariel]
    IP_ADDRESSES_TO_ACCEPT = %w[192.168.34.162]

    def authenticate
      if HOSTNAMES_TO_REJECT.include?(`hostname`.chomp) \
          && !IP_ADDRESSES_TO_ACCEPT.include?(ip_address_of_client)
        render plain: 'Rejected'
        return
      end
    end

    def ip_address_of_client
      request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
    end

    def sire_filter_params
      return {} unless params[:sire_filter]
      params.require(:sire_filter).permit(
        :growth, :temper, :contend, :health, :stability
      )
    end
end
