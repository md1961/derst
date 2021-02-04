class Results::G1ByYearsController < ApplicationController

  def show
    @races = Race.joins(:grade)
                 .where("grades.abbr = 'Ⅰ'")
                 .order(:month, :week)
                 .reject(&:oversea?)
    @results_by_race_and_year = Result.joins(race: :grade)
                                      .where("grades.abbr = 'Ⅰ'")
                                      .group_by(&:year)
                                      .map { |year, results|
                                        [year, results.group_by { |result| result.race.id }]
                                      }.to_h
    @years = @results_by_race_and_year.keys.minmax.yield_self { |min, max| (min .. max) }
  end
end
