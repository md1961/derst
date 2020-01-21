$ ->
  if $('.ranch_mares_show').length > 0
    bottoms = $.map($('div.bloodline div.root_lineages'), (e) => $(e).offset().top + $(e).height())
    bottom = Math.max(bottoms...)
    $div_link = $('div.links').eq(0)
    offset = $div_link.offset()
    offset.top = bottom + 20
    $div_link.offset(offset)
