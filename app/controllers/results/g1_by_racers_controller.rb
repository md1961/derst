class Results::G1ByRacersController < ApplicationController

  DEFAULT_YEAR_START = Ranch.last.year - 2

  def show
    @year_start = [(params[:year_start] || DEFAULT_YEAR_START).to_i, DEFAULT_YEAR_START].min
    @year_end   = @year_start + 2

    @races = Race.joins(:grade)
                 .where("grades.abbr = 'Ⅰ'")
                 .order(:month, :week)
                 .reject(&:oversea?)

    @results_by_racer_year_and_race = \
        Result.high_stake(1)
              .find_all { |result| result.year.between?(@year_start, @year_end) }
              .group_by { |result| result.racer }
              .map { |racer, results|
                [
                  racer,
                  results.group_by { |result|
                    [result.year, result.race.id]
                  }.map { |key, results|
                    [key, results&.first]
                  }.to_h
                ]
              }.to_h

    @racers = @results_by_racer_year_and_race.keys.sort_by { |racer| -racer.net_prize }
  end
end
