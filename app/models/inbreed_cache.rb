class InbreedCache < ApplicationRecord
  belongs_to :mare
  belongs_to :sire

  def update_inbreeds(h_inbreeds)
    update(
      h_inbreeds_in_json: h_inbreeds.map { |father, generations|
        [father.id, generations]
      }.to_h.to_json
    )
  end

  def fetch_h_inbreeds
    JSON.parse(h_inbreeds_in_json).map { |father_id, generations|
      [Sire.find(father_id), generations]
    }.to_h rescue nil
  end
end
