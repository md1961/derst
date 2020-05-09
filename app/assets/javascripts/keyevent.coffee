$ ->
  select_next_option = (elem) ->
    elem.children('option:selected').next().prop('selected', true)

  select_prev_option = (elem) ->
    elem.children('option:selected').prev().prop('selected', true)

  $(window).on 'keypress', (e) ->
    if e.ctrlKey
      return
    if $('input[type="text"]').not('.allows_shortcut').is(':focus')
      return
    key = String.fromCharCode(e.which)
    if $('input[type="number"]').not('.allows_shortcut').is(':focus') && [1 .. 9].includes(parseInt(key)) \
        && $('#racer_menu').length == 0
      return

    if $('#results').hasClass('ready_for_race') && $('select.mark').is(':focus') \
        && ['a', 'b', 'c', 'y', 'z', 'j', 'k', 'o'].includes(key)
      $mark_selects = $('select.mark:focus').closest('tr').find('select.mark')
      if key == 'j'
        $.each($mark_selects, -> select_next_option($(this)))
      else if key == 'k'
        $.each($mark_selects, -> select_prev_option($(this)))
      else if key == 'o'
        $.each($mark_selects, -> $(this).val($(this).data('orig-value')))
      else
        value = if key == 'a' then '－' else if key == 'b' then '△' else
                if key == 'c' then '▲' else if key == 'y' then '〇' else '◎'
        $.each($mark_selects, -> $(this).val(value))
      return

    if $('#show_mares').length > 0 && key == 'y'
      if $('table.all_racers').is(':visible')
        $('div.mares').toggle()
      else
        $('#show_mares')[0].click()
      return
    else if $('div.racers_racers').length > 0 && $('div#racer_menu').length == 0 && key == 'x'
      $('div.racers_racers tr.age2_or_1').toggle()
      return
    else if $('#show_inbreeds').length > 0 && key == 'w'
      $('#progress_dialog').show()
      $('#show_inbreeds')[0].click()
      return
    else if $('#show_all_racers').length > 0 && key == 'z'
      $('#show_all_racers')[0].click()
      return
    else if $('table.all_racers').is(':visible') && key == 'r'
      $('.default')  .toggle()
      $('.optional1').toggle()
      return

    if $('#racer_menu').length > 0 && key == 'z'
      $('#racer_menu').toggle()
      $('#race_candidates').toggle()
      $('#conditions').toggle()
      return

    if $('.matings_show').length > 0 && (key == 'j' || key == 'k')
      if key == 'k'
        $('#to_prev_mating')[0].click()
      else if key == 'j'
        $('#to_next_mating')[0].click()
      return

    if ($('select.condition').is(':focus') || $('input.weight').is(':focus')) && key == ','
      racer_id = $(':focus').data('racer-id')
      $.post '/racers/' + racer_id + '/increment_weight_fat'
      return false

    if $('#racer_weight_fat').is(':focus') && key == '.'
      $('span.fat_to_best')[0].click()
      return false
    if $('#racer_weight_lean').is(':focus') && key == ','
      $('span.lean_to_best')[0].click()
      return false

    if $('input.weight').is(':focus') && key.match(/^[a-zA-Z.]$/)
      $input_weight = $(':focus')
      racer_id = $input_weight.data('racer-id')
      if key == 'f' || key == 'l'
        weight = $input_weight.val()
        action = '/racers/' + racer_id + '/weight_' + (if key == 'f' then 'fat' else 'lean')
        $.post action, {weight: weight}
      else if key == '.'
        $.post '/racers/' + racer_id + '/weight_best'
      return false

    if $('div.all_racers').length > 0 && key != 'z'
      if '1' <= key && key <= '9'
        $('tbody tr').hide()
        $('tbody tr.age-' + key).show()
      else
        $('tbody tr').show()
      return

    key = '=' if key == '"'
    $links = $('[data-shortcut="' + key + '"]:visible')
    if $links.length > 0
      $link = $links.eq(0)
      $('#progress_dialog').show() if $link.is('a')
      $link[0].click()
      return false

  $(window).on 'keydown', (e) ->
    $focused = $(':focus')
    if $focused.attr('name') == 'condition' && e.keyCode == 13
      $form = $focused.parent('form')
      action = $form.attr('action')
      condition = $focused.val()
      $.post action, {condition: condition}
      return false

  $(window).on 'keyup', (e) ->
    if e.keyCode == 27
      if $('.esc_hideable:visible').length > 0
        if $('#racer_menu').is(':visible')
          $('#race_candidates').show()
          $('#conditions').show()
        $('.esc_hideable:visible').hide()
      else if $('.escapeable').length > 0
        $('#progress_dialog').show() unless $('.escapeable').eq(0).hasClass('no_progress')
        $('.escapeable')[0].click()
