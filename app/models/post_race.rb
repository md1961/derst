class PostRace < ApplicationRecord
  belongs_to :result

  after_save :injure_racer

  private

    def injure_racer
      description = comment.to_s.split.last
      return if description.blank?
      result.racer.injure(description)
    end
end
