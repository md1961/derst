$ ->
  $(window).on 'keydown', (e) ->
    if $('input[type="text"]').is(':focus') || e.ctrlKey
      return
    key = String.fromCharCode(e.which).toLowerCase()
    $('a[data-shortcut="' + key + '"]').focus()

  $('#show_retired_racers').on 'click', ->
    $(this).next('table').toggle()
