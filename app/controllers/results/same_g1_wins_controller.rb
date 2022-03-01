class Results::SameG1WinsController < ApplicationController

  def show
    @results_by_racer = Result.multiple_same_g1_race_winners
  end
end
