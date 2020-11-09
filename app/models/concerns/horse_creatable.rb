module HorseCreatable

  def create_from_mating_of(mother, father, name = nil)
    name = name_by_mating_of(mother, father) unless name
    ApplicationRecord.transaction do
      create!(name: name, father: father, lineage: father.trait.lineage).tap { |horse|
        horse.maternal_lines.create!(generation: 2, father: mother.father)
        horse.maternal_lines.create!(generation: 3, father: mother.bloodline_father(2, 2))
        horse.maternal_lines.create!(generation: 4, father: mother.bloodline_father(3, 4))
      }
    end
  end
end
