module ResultsHelper

  def grade_class(grade)
    return '' unless grade.high_stake?
    "g-#{{'Ⅰ': 1, 'Ⅱ': 2}[grade.abbr.to_sym] || 3}"
  end
end
