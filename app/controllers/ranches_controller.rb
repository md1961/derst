class RanchesController < ApplicationController

  def show
    @ranch = Ranch.last
    @mares = @ranch.mares
  end
end
