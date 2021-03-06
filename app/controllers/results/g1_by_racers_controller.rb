class Results::G1ByRacersController < ApplicationController

  DEFAULT_YEAR_END = Ranch.last.year

  def show
    @racer_age = params[:racer_age]
    age_filter = AgeFilter.new(@racer_age)

    @year_end   = [(params[:year_end] || DEFAULT_YEAR_END).to_i, DEFAULT_YEAR_END].min
    @year_start = @year_end - age_filter.years_to_display + 1

    @races = Race.joins(:grade)
                 .where("grades.abbr = 'Ⅰ'")
                 .where(age_filter.race_condition)
                 .order(:month, :week)
                 .reject(&:oversea?)

    @results_by_racer_year_and_race = \
        Result.high_stake(1)
              .find_all { |result| @races.include?(result.race) }
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

  class AgeFilter

    def initialize(age)
      @age = age&.to_sym
    end

    def years_to_display
      case @age
      when :'4'
        8
      when :'4U'
        5
      else
        3
      end
    end

    def race_condition
      case @age
      when :'4'
        "age = '4'"
      when :'4U'
        "age LIKE '%U'"
      else
        nil
      end
    end
  end
end
