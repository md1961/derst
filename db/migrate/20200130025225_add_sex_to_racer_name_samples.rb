class AddSexToRacerNameSamples < ActiveRecord::Migration[5.2]

  def change
    add_column :racer_name_samples, :sex, :integer, null: false, default: 0
  end
end
