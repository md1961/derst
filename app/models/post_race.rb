class PostRace < ApplicationRecord
  belongs_to :result

  after_save :injure_racer

  private

    def injure_racer
      description = comment.to_s.split.last
      return if description.blank?
      if description == '去勢'
        result.racer.gelding!
        return
      end
      result.racer.injure(description)
    end
end
