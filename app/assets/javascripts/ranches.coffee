$ ->
  $(window).on 'keydown', (e) ->
    if $('input[type="text"]').is(':focus') || e.ctrlKey
      return
    key = String.fromCharCode(e.which).toLowerCase()

    if $('.matings_show').length > 0 && (key == 'j' || key == 'k')
      if key == 'k'
        $('#to_prev_mating')[0].click()
      else if key == 'j'
        $('#to_next_mating')[0].click()

    if $('.racers_show').length > 0 && (key == 'j' || key == 'k')
      if key == 'k'
        $('#to_prev_racer')[0].click()
      else
        $('#to_next_racer')[0].click()
      return

    links = $('a[data-shortcut="' + key + '"]')
    if key == 'b' && $('.ranches_show').length == 0
      links[0].click()
    else
      links.focus()

  $('#show_retired_racers').on 'click', ->
    $(this).next('table').toggle()
