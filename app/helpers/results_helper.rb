module ResultsHelper

  def grade_class(grade)
    return '' unless grade.high_stake?
    "g-#{{'Ⅰ': 1, 'Ⅱ': 2}[grade.abbr.to_sym] || 3}"
  end

  def racers_display(results)
    return nil if results.nil? || results.empty?
    content_tag(:span, style: 'display: flex') do
      results.group_by(&:racer).map { |racer, results|
        age_display = results.map { |result|
          result.race.age.ends_with?('U') ? result.age : nil
        }.compact.map { |age|
          "#{age}歳"
        }.join(', ')
        [link_to(racer, racer, target: 'blank'), age_display].join('&nbsp;')
      }.join('、').html_safe
    end
  end
end
