module RacersHelper

  def sire_trait_display(sire)
    return "" unless sire
    trait = sire.trait
    return "" unless trait
    "#{trait.distances}、#{trait.dirt}、#{trait.growth}"
  end

  def mare_trait_display(mare)
    return "" unless mare
    "スピード #{mare.speed}、スタミナ #{mare.stamina}"
  end

  def race_display(race)
    course = race.course
    stable = @racer.stable
    transport = course.same_from?(stable) ? 'same' \
              : course.on_the_day_from?(stable) ? 'on_day' : 'remote'

    a = []
    a << race.age.sub(/\A(\d)/, '\1歳').sub('U', '上')
    a << race.grade
    a << "#{race.distance}#{race.dirt? ? 'D' : ''}"
    a << (race.female_only? ? '牝' : race.domestic_only? ? '父' : nil)
    a << race.name
    a << race.weight_to_s

    safe_join([
      content_tag(:td, course, class: transport),
      content_tag(:td, a.join(' '))
    ])
  end
end
