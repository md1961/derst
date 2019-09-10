module BloodlineTrackable

  def each_generation_and_number
    Enumerator.new do |y|
      (1 .. 4).each do |generation|
        (1 .. 2 ** (generation - 1)).each do |number|
          y << [generation, number]
        end
      end
    end
  end

  def all_bloodline_father_present?
    each_generation_and_number.all? { |generation, number|
      bloodline_father(generation, number)
    }
  end

  def bloodline_father(generation, number)
    child_of_bloodline_father(generation, number)&.father
  end

  def update_bloodline_father(generation, number, name)
    sire = Sire.find_by_name(name)
    return false unless sire
    # TODO: Display error message when no child_of_bloodline_father.
    child_of_bloodline_father(generation, number)&.update!(father: sire)
    true
  end

  def destroy_bloodline_father(generation, number)
    child = child_of_bloodline_father(generation, number)
    case child
    when Sire
      child.update!(father: nil)
    when SireMaternalLine
      child.destroy
    end
  end

  private

    def child_of_bloodline_father(generation, number)
      case generation
      when 1
        self
      when 2
        case number
        when 1
          father
        else
          maternal_lines.find_or_initialize_by(generation: 2)
        end
      when 3
        case number
        when 1
          father&.father
        when 2
          father&.maternal_lines&.find_or_initialize_by(generation: 2)
        when 3
          bloodline_father(2, 2)
        else
          maternal_lines.find_or_initialize_by(generation: 3)
        end
    # 父　父父　父父父　父父父父
    #                   父父母父
    #           父母父　父母父父
    #                   父母母父
    #     母父　母父父　母父父父
    #                   母父母父
    #           母母父　母母父父
    #                   母母母父
      when 4
        case number
        when 1
          bloodline_father(3, 1)
        when 2
          bloodline_father(2, 1)&.maternal_lines&.find_or_initialize_by(generation: 2)
        when 3
          bloodline_father(3, 2)
        when 4
          bloodline_father(1, 1)&.maternal_lines&.find_or_initialize_by(generation: 3)
        when 5
          bloodline_father(3, 3)
        when 6
          bloodline_father(2, 2)&.maternal_lines&.find_or_initialize_by(generation: 2)
        when 7
          bloodline_father(3, 4)
        else
          maternal_lines.find_or_initialize_by(generation: 4)
        end
      end
    end
end
