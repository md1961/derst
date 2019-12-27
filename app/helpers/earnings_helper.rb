module EarningsHelper

  def results_display(results)
    safe_join(results.sort_by { |result|
      -result.prize
    }.map { |result|
      race_name_display(result.race).yield_self { |x|
        result.place == 1 ? x : x + " #{result.place}着"
      }
    }, '、')
  end
end
