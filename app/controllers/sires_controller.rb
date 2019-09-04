class SiresController < ApplicationController

  def index
    @sires = Sire.all
  end
end
