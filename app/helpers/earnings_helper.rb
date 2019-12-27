module EarningsHelper

  def results_display(results)
    safe_join(
      results.sort_by { |result|
        -result.prize
      }.map { |result|
        race_name_display(result.race).yield_self { |x|
          result.place == 1 ? x : x + " #{result.place}着"
        }
      },
      '、'
    )
  end

  def total_by_racer_display(earnings)
    safe_join(
      earnings.each_with_object(Hash.new(0)) { |earning, h|
        earning.total_by_racer.each do |racer, total|
          h[racer] += total
        end
      }.sort_by { |_, total|
        -total
      }.map { |racer, total|
        "#{racer} #{total}"
      },
      '<br>'.html_safe
    )
  end
end
