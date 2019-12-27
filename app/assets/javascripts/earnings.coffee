$ ->
  $('.earnings_index .clickable').on 'click', ->
    rows = $(this).attr('rowspan')
    $(this)
      .parent()
        .nextAll().andSelf().slice(0, rows)
          .children('.hideable').toggle()
