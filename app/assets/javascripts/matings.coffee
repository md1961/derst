$ ->
  filter = ->
    shows_interesting_only = $('#header_interesting').hasClass('interesting_only')
    shows_nicks_only = $('#header_nicks').hasClass('nicks_only')
    if shows_interesting_only && shows_nicks_only
      $('tbody tr').hide()
      $('td.nicks').parent('tr').has('td.interesting').show()
    else if shows_nicks_only
      $('tbody tr').hide()
      $('td.nicks').parent('tr').show()
    else if shows_interesting_only
      $('tbody tr').hide()
      $('td.interesting').parent('tr').show()
    else
      $('tbody tr').show()

  $('#header_nicks').on 'click', ->
    $(this).toggleClass('nicks_only')
    filter()

  $('#header_interesting').on 'click', ->
    $(this).toggleClass('interesting_only')
    filter()
