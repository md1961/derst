module StringConsideringMultiByteLength

  refine String do

    def mb_length
      each_char.map { |c| c.bytesize == 1 ? 1 : 2 }.sum
    end
   
    def mb_ljust(width, padding=' ')
      padding_size = [0, width - mb_length].max
      self + padding * padding_size
    end
  end
end

using StringConsideringMultiByteLength

max_name_len = Race.pluck(:name).compact.map(&:mb_length).max

Race.includes(:grade).order(:age, :grade_id, :month, :week).find_all { |race|
  race.grade.high_stake?
}.each do |race|
  puts "#{race.age.ljust(2)} #{race.grade} #{race.month_week.to_s.rjust(4)} #{race.name.mb_ljust(max_name_len)} = "
end
