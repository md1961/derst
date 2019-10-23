class RacerNameSample < ApplicationRecord

  validates :name, presence: true, length: {in: 2 .. 9}

  after_initialize :name_to_katakana

  def to_s
    name
  end

  private

    using StringJapanese

    def name_to_katakana
      self.name = name&.to_katakana
    end
end