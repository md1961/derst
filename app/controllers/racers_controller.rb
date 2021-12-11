class RacersController < ApplicationController
  before_action :set_main_display_for_ranch, only: %i[show edit update]

  def by_mother
    @racers_by_mother = Racer.all.group_by(&:mother).map { |mother, racers|
      [mother, racers.sort_by!(&:year_birth)]
    }.sort_by { |_, racers|
      -racers.last.year_birth
    }.to_h

    @html_title = '産駒一覧'
    @no_top_bar = true
  end

  def show
    @racer = Racer.includes(:weeklies, results: {race: :grade}, target_races: {race: :grade}).yield_self { |r|
               r.find(params[:id]) rescue r.find_by(name: params[:id])
             }
    @result_id_to_edit = params[:result_id_to_edit].to_i
    @post_race = PostRace.find_by(id: params[:post_race_id_to_edit])

    @includes_overgrade = params[:includes_overgrade] == 'true' \
      || @racer.target_races.includes(race: :grade).any? { |target_race| target_race.race.grade > @racer.grade }
    @weeks_for_race_candidates = @racer.open? || @racer.age == 4 ? (params[:more_candidates] ? 24 : 16) : 12
    @race_ids_targeted = @racer.target_races.map(&:race).map(&:id)
    @target_races_by_others = TargetRace.includes(:race, :racer).where.not(racer: @racer)
    @entered_races_by_others = Result.where(place: nil).includes(:race, :racer).where.not(racer: @racer)

    racers = (@racer.in_stable? ? Racer.in_stable : Racer.in_ranch).sort_by(&:ordering_for_list)

    @racers_in_same_race = []
    if @racer.in_stable? && Racer.all_training_done?
      race = @racer.results.in_current_week.last.yield_self { |result| result&.age == @racer.age ? result.race : nil }
      if races_of_multiple_entries(racers).include?(race)
        @racers_in_same_race = racers.find_all { |racer|
          last_result = racer.results.last
          last_result&.age == racer.age && last_result&.race == race && racer != @racer
        }
      end
      racers_expecting_in_same_race = @racers_in_same_race.find_all(&:expecting_race?).yield_self { |racers|
        racers + (!@racers_in_same_race.empty? && @racer.expecting_race? ? [@racer] : [])
      }
      racers = racers.find_all { |racer|
        if racers_expecting_in_same_race.empty?
          racer.expecting_race? || racer == @racer
        else
          (racers_expecting_in_same_race.include?(racer) && racer.expecting_race?) || racer == @racer
        end
      }
    else
      racers = racers.reject { |racer| racer.condition && racer != @racer }
    end

    index = racers.find_index(@racer)
    @prev_racer, @next_racer = (racers + racers).values_at(index - 1, index + 1) if index && racers.size >= 2

    flash[:racer_id_to_focus] = @racer.id

    racer_ids_shown = session[:racer_ids_shown] || []
    racer_ids_shown.pop if racer_ids_shown.last == @racer.id
    @racer_shown_last = Racer.find_by(id: racer_ids_shown.last)
    racer_ids_shown.push(@racer.id)
    session[:racer_ids_shown] = racer_ids_shown.last(2)
  end

  def new
    @racer = Racer.new(params.permit(:ranch_id, :father_id, :mother_id))
    ranch_mare = @racer.ranch.ranch_mares.find_by(mare: @racer.mother, sire: @racer.father)
    @racer.age = ranch_mare ? 1 : 2
    @remark = ranch_mare&.remark
  end

  def create
    @racer = Racer.new(racer_params)
    ranch_mare = @racer.ranch.ranch_mares.find_by(mare: @racer.mother, sire: @racer.father)
    ApplicationRecord.transaction do
      @racer.save!
      ranch_mare&.update!(sire: nil)
      ranch_mare&.default_child_status!
      redirect_to @racer.ranch
    end
  end

  def edit
    @racer = Racer.find(params[:id])
    @editing = true
    render :show
  end

  def update
    @racer = Racer.find(params[:id])
    ranch = Ranch.find_by(id: params[:ranch_id])
    if @racer.update(racer_params)
      flash[:racer_id_to_focus] = @racer.id
      redirect_to ranch || racer_path(@racer, main_display: @main_display)
    elsif ranch
      redirect_to ranch_path(ranch, racer_id_to_edit: @racer)
    else
      @editing = true
      render :show
    end
  end

  def create_result
    racer = Racer.find(params[:id])
    attrs = {race_id: params[:race_id], age: racer.age, condition: racer.condition}
    last_result = racer.results.last
    if last_result
      %i[
        weight mark_development mark_stamina mark_contend mark_temper mark_odds
        load jockey_id for_bad_surface position
      ].each do |name|
        attrs[name] = last_result.send(name)
      end
    end
    attrs[:weight] = racer.weight || racer.weight_best if attrs[:weight].blank?
    Result.transaction do
      racer.results.create(attrs).tap { |result|
        result.set_load_from_racer_and_race!
        course_race = result.race.course
        if course_race.needs_trip_from?(racer.stable) || params[:trip] == 'true'
          racer.trip_to(course_race)
        end
        course_staying = racer.course_staying
        if course_staying && course_staying != course_race
          if course_staying.hokkaido? && course_race.hokkaido?
            racer.trip_to(course_race)
          else
            racer.trip_back
          end
        end
      }
    end
    redirect_to racer
  end

  def condition
    @racer = Racer.find(params[:id])
    condition = params[:condition]
    condition = nil if condition == '-'
    @racer.condition = condition
  end

  def weight
    @racer = Racer.find(params[:id])
    weight = params[:weight].to_i
    weight = nil if weight < 300 || weight > 600
    @racer.weight = weight
  end

  def weight_fat
    @racer = Racer.find(params[:id])
    weight = params[:weight].to_i
    @racer.update!(weight_fat: weight, weight_best: nil, weight_lean: nil) if weight >= 300
    render :weight_update
  end

  def weight_lean
    @racer = Racer.find(params[:id])
    weight = params[:weight].to_i
    @racer.update!(weight_lean: weight, weight_best: weight + 2, weight_fat: nil) if weight >= 300
    render :weight_update
  end

  def weight_best
    @racer = Racer.find(params[:id])
    @racer.update!(weight_best: @racer.weight_fat - 10) if @racer.weight_fat
    render :weight_update
  end

  def increment_weight_fat
    @racer = Racer.find(params[:id])
    if @racer.weight_best
      Racer.transaction do
        @racer.update!(weight_fat: @racer.weight_best + 10) unless @racer.weight_fat
        @racer.update!(weight_lean: nil)
        @racer.increment!(:weight_fat , 2)
        @racer.increment!(:weight_best, 2)
      end
    end
    render :weight_update
  end

  def graze
    racer = Racer.find(params[:id])
    racer.graze!
    redirect_to racer.ranch
  end

  def ungraze
    racer = Racer.find(params[:id])
    racer.ungraze!
    redirect_to racer.ranch
  end

  def spa
    racer = Racer.find(params[:id])
    racer.spa!
    redirect_to racer.ranch
  end

  def trip
    racer = Racer.find(params[:id])
    if racer.course_staying
      racer.trip_back
    elsif racer.results.last
      racer.trip_to(racer.results.last.race.course)
    end
    redirect_to racer
  end

  def injure
    racer = Racer.find(params[:id])
    racer.injure(params[:description])
    redirect_to racer
  end

  def create_mare
    racer = Racer.find(params[:id])
    racer.create_mare
    redirect_to racer
  end

  def retire
    racer = Racer.find(params[:id])
    ranch = racer.ranch
    racer.retire!
    redirect_to ranch
  end

  private

    def racer_params
      params.require(:racer).permit(
        :ranch_id, :name, :sex, :age, :grade_given_id,
        :comment_age2, :comment_age3, :stable_id, :weight_fat, :weight_best, :weight_lean, :remark
      ).tap { |p|
        father = Sire.find_by_name( params[:father])
        mother = Mare.find_by(name: params[:mother])
        p[:father] = father if father
        p[:mother] = mother if mother
      }
    end

    def races_of_multiple_entries(racers)
      racers.map { |racer|
        racer.results.in_current_week.last.yield_self { |result| result&.age == racer.age ? result.race : nil }
      }.compact.group_by(&:itself).find_all { |race, races|
        races.size >= 2
      }.map(&:first)
    end

    def set_main_display_for_ranch
      @main_display = params[:main_display].yield_self { |x| x.blank? ? nil : x }
    end
end
