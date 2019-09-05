module BloodlineTrackable

  def bloodline_father(generation, number)
    child_of_bloodline_father(generation, number)&.father
  end

  def update_bloodline_father!(generation, number, name)
    sire = Sire.find_by_name(name)
    # TODO: Display error message when cannot find sire by name.
    return unless sire
    child_of_bloodline_father(generation, number).update!(father: sire)
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
          father&.maternal_lines.find_or_initialize_by(generation: 2)
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
          bloodline_father(2, 1)&.maternal_lines.find_or_initialize_by(generation: 2)
        when 3
          bloodline_father(3, 2)
        when 4
          bloodline_father(1, 1)&.maternal_lines.find_or_initialize_by(generation: 3)
        when 5
          bloodline_father(3, 3)
        when 6
          bloodline_father(2, 2)&.maternal_lines.find_or_initialize_by(generation: 2)
        when 7
          bloodline_father(3, 4)
        else
          maternal_lines.find_or_initialize_by(generation: 4)
        end
      end
    end
end
