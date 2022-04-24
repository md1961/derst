class BloodlineController < ApplicationController

  def edit
    @sire = Sire.find(params[:sire_id])
  end

  def update
    horse_class = params[:type].constantize
    horse = horse_class.find(params[:id])

    key, father_name = params_father.first
    key =~ /\Afather(\d)(\d)\z/
    generation = Regexp.last_match(1).to_i
    number     = Regexp.last_match(2).to_i
    is_updated = horse.update_bloodline_father(generation, number, father_name)

    if is_updated || params_father.empty?
      redirect_to bloodline_edit_path(sire_id: horse)
    else
      redirect_to new_sire_path(name: father_name,
                                horse_back_type: horse.class.name, horse_back_id: horse.id,
                                generation: generation, number: number)
    end
  end

  def destroy
    horse_class = params[:type].constantize
    horse = horse_class.find(params[:id])
    generation = params[:generation].to_i
    number     = params[:number    ].to_i
    horse.destroy_bloodline_father(generation, number)
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
