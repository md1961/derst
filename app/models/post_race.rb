class PostRace < ApplicationRecord
  belongs_to :result

  after_save :injure_racer

  RE_DESCRIPTION_FOR_INJURY = /(?:重傷|骨折|屈腱炎|ハ行|ソエ|復帰困難)/

  def description
    @description ||= comment.to_s.split.last
  end

  def injury?
    description =~ RE_DESCRIPTION_FOR_INJURY
  end

  def age_in_week
    age_in_week = result.age_in_week
    if m = comment.match(/\A(\d+)\D(\d+)/)
      month = m[1].to_i
      week  = m[2].to_i
      age = age_in_week.age
      age += 1 if month < age_in_week.month || (month == age_in_week.month && week < age_in_week.week)
      Racer::AgeInWeek.new(age, month, week)
    else
      age_in_week
    end
  end

  private

    def injure_racer
      return if description.blank?
      if description == '去勢'
        result.racer.gelding!
        return
      end
      result.racer.injure(description) if injury?
    end
end
