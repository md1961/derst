class MonthWeek
  attr_reader :month, :week

  def initialize(month, week)
    raise "Illegal month (#{month})" unless (1 .. 12) === month
    raise "Illegal week (#{week})"   unless (1 ..  4) === week
    @month = month
    @week  = week
  end

  def first_of_year?
    [month, week] == [1, 1]
  end

  def -(other)
    raise "Argument must be a MonthWeek (#{other.class} given)" unless other.is_a?(self.class)
    if month == other.month
      diff = week - other.week
      diff += 4 * 12 if diff < 0
    else
      month_diff = month - other.month
      month_diff += 12 if month_diff < 0
      diff = month_diff * 4 + week - other.week
    end
    diff
  end

  def next
    new_month = month
    new_week = week + 1
    if new_week > 4
      new_week = 1
      new_month += 1
      if new_month > 12
        new_month = 1
      end
    end
    self.class.new(new_month, new_week)
  end

  def ==(other)
    raise "Argument must be a MonthWeek (#{other.class} given)" unless other.is_a?(self.class)
    month == other.month && week == other.week
  end

  def eql?(other)
    self == other
  end

  def hash
    [month, week].hash
  end

  def to_params
    {month: month, week: week}
  end

  def to_a
    [month, week]
  end

  def to_s
    [month, week].join('.')
  end
end
