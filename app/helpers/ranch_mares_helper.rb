module RanchMaresHelper

  def ranch_mare_link(ranch_mare, index)
    label = "[#{index}] #{ranch_mare}（#{ranch_mare.sire&.name || '空胎'}）"
    content_tag(:span, class: 'label') {
      link_to_if(
        ranch_mare != @ranch_mare,
        label,
        ranch_mare,
        data: {shortcut: index},
        tabindex: -1
      )
    }
  end
end
