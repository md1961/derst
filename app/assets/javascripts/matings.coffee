$ ->
  filter = ->
    shows_interesting_only = $('#header_interesting').hasClass('interesting_only')
    if shows_interesting_only
      $('tbody tr').hide()
      $('td.interesting').parent('tr').show()
    else
      $('tbody tr').show()

  $('#header_interesting').on 'click', ->
    $(this).toggleClass('interesting_only')
    filter()
