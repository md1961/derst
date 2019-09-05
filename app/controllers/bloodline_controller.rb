class BloodlineController < ApplicationController

  def update
    horse_class = params[:type].constantize
    horse = horse_class.find(params[:id])

    ApplicationRecord.transaction do
      params_father.each do |key, father_name|
        next unless key =~ /\Afather(\d)(\d)\z/
        generation = Regexp.last_match(1).to_i
        number     = Regexp.last_match(2).to_i
        horse.update_bloodline_father!(generation, number, father_name)
      end
    end

    redirect_to horse
  end

  private

    def params_father
      params.permit(
        :father11,
        :father21, :father22,
        :father31, :father32, :father33, :father34,
        :father41, :father42, :father43, :father44, :father45, :father46, :father47, :father48
      ).to_h.find_all { |k, v|
        k =~ /\Afather\d\d\z/ && v.present?
      }.to_h
    end
end
