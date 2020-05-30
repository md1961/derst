$ ->
  if $('.ranch_mares_show').length > 0
    $('input#remark').on 'input', ->
      if $(this).val() == $(this).data('orig-value')
        $(this).css('background-color', 'white')
      else
        $(this).css('background-color', 'lightpink')

    bottoms = $.map($('div.bloodline div.root_lineages'), (e) => $(e).offset().top + $(e).height())
    bottom = Math.max(bottoms...)
    $div_link = $('div.ranch_mares_show div.links').eq(0)
    offset = $div_link.offset()
    offset.top = bottom + 20
    $div_link.offset(offset)
