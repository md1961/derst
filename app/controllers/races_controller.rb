class RacesController < ApplicationController

  def index
    @month = (params[:month] || 1).to_i
    @races_by_course = Race.where("month = ?", @month).group_by(&:course)
  end

  def weights
    @results_by_sex = Result.includes(:racer, :race).all.group_by { |result|
      sex = result.racer.sex
      sex == 'gelding' ? 'male' : sex
    }.map { |sex, results|
      [
        sex,
        results.find_all { |result|
          result.race.age_constant?
        }.uniq { |result|
          [result.age, result.race.month, result.race.grade]
        }.sort_by { |result|
          result.age * 10000 + result.race.month * 100 + result.race.grade.ordering
        }
      ]
    }.to_h
  end
end
