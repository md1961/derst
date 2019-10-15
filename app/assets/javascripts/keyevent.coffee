$ ->
  $(window).on 'keypress', (e) ->
    if $('input[type="text"]').is(':focus') || e.ctrlKey
      return
    key = String.fromCharCode(e.which)

    if $('#show_all_racers').length > 0 && key == 'z'
      $('#show_all_racers')[0].click()
      return

    if $('#racer_menu').length > 0 && key == 'z'
      $('#racer_menu').toggle()
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

    if $('#results').hasClass('ready_for_race') && (key == 'a' || key == 'z')
      value = if key == 'a' then '－' else '◎'
      $('#result_mark_development').val(value)
      $('#result_mark_stamina').val(value)
      $('#result_mark_contend').val(value)
      $('#result_mark_temper').val(value)
      $('#result_mark_odds').val(value)
      return

    key = '=' if key == '"'
    links = $('a[data-shortcut="' + key + '"]:visible')
    links[0].click()
