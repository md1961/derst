$ ->
  $(window).on 'keypress', (e) ->
    if $('input[type="text"]').is(':focus') || e.ctrlKey
      return
    key = String.fromCharCode(e.which)

    if $('#show_retired_racers').length > 0
      $('#show_retired_racers')[0].click()
      return

    if $('.matings_show').length > 0 && (key == 'j' || key == 'k')
      if key == 'k'
        $('#to_prev_mating')[0].click()
      else if key == 'j'
        $('#to_next_mating')[0].click()
      return

    if $('.racers_show').length > 0 && (key == 'j' || key == 'k')
      if key == 'k'
        $('#to_prev_racer')[0].click()
      else
        $('#to_next_racer')[0].click()
      return

    key = '=' if key == '"'
    links = $('a[data-shortcut="' + key + '"]')
    links[0].click()
