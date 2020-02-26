class PostRace < ApplicationRecord
  belongs_to :result

  after_save :injure_racer

  private

    RE_DESCRIPTION_FOR_INJURY = /(?:骨折|屈腱炎|ハ行|ソエ)\z/

    def injure_racer
      description = comment.to_s.split.last
      return if description.blank?
      if description == '去勢'
        result.racer.gelding!
        return
      end
      result.racer.injure(description) if description =~ RE_DESCRIPTION_FOR_INJURY
    end
end
