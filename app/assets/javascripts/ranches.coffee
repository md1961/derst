$ ->
  $(window).on 'keydown', (e) ->
    if $('input[type="text"]').is(':focus') || e.ctrlKey
      return
    key = String.fromCharCode(e.which).toLowerCase()
    links = $('a[data-shortcut="' + key + '"]')
    if key == 'b' && $('.ranches_show').length == 0
      links[0].click()
    else
      links.focus()

  $('#show_retired_racers').on 'click', ->
    $(this).next('table').toggle()
