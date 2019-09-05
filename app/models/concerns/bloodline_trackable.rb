module BloodlineTrackable

  def bloodline_father(generation, number)
    case generation
    when 1
      father
    when 2
      case number
      when 1
        father.father
      else
        maternal_lines.find_by(generation: 2)&.father
      end
    when 3
      case number
      when 1
        father.father&.father
      when 2
        father.bloodline_father(2, 2)
      when 3
        bloodline_father(2, 2)&.father
      else
        maternal_lines.find_by(generation: 3)&.father
      end
    when 4
      case number
      when 1
        bloodline_father(3, 1)&.father
      when 2
        bloodline_father(2, 1)&.bloodline_father(2, 2)
      when 3
        bloodline_father(3, 2)&.father
      when 4
        bloodline_father(2, 2)&.bloodline_father(2, 2)
      when 5
        bloodline_father(3, 3)&.father
      when 6
        bloodline_father(2, 3)&.bloodline_father(2, 2)
      when 7
        bloodline_father(3, 4)&.father
      else
        maternal_lines.find_by(generation: 4)&.father
      end
    end
  end
end
