class PostRace < ApplicationRecord
  belongs_to :result

  after_save :injure_racer

  RE_DESCRIPTION_FOR_INJURY = /(?:重傷|骨折|屈腱炎|ハ行|ソエ)\z/

  def description
    @description ||= comment.to_s.split.last
  end

  def injury?
    description =~ RE_DESCRIPTION_FOR_INJURY
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
