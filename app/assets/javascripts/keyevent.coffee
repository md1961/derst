$ ->
  $mark_selects = [
    $('#result_mark_development'),
    $('#result_mark_stamina'),
    $('#result_mark_contend'),
    $('#result_mark_temper'),
    $('#result_mark_odds')
  ]

  select_next_option = (elem) ->
    elem.children('option:selected').next().prop('selected', true)

  select_prev_option = (elem) ->
    elem.children('option:selected').prev().prop('selected', true)

  $(window).on 'keypress', (e) ->
    if $('input[type="text"]').is(':focus') || e.ctrlKey
      return
    key = String.fromCharCode(e.which)

    is_mark_focused = $mark_selects.some((elem) -> elem.is(':focus'))
    if $('#results').hasClass('ready_for_race') && is_mark_focused \
        && ['a', 'b', 'c', 'y', 'z', 'j', 'k', 'o'].includes(key)
      if key == 'j'
        $.each($mark_selects, -> select_next_option(this))
      else if key == 'k'
        $.each($mark_selects, -> select_prev_option(this))
      else if key == 'o'
        $.each($mark_selects, -> this.val(this.data('orig-value')))
      else
        value = if key == 'a' then '－' else if key == 'b' then '△' else
                if key == 'c' then '▲' else if key == 'y' then '〇' else '◎'
        $.each($mark_selects, -> this.val(value))
      return

    if $('#show_mares').length > 0 && key == 'y'
      if $('table.all_racers').is(':visible')
        $('div.mares').toggle()
      else
        $('#show_mares')[0].click()
      return
    else if $('#show_no_stable').length > 0 && key == 'x'
      $('#show_no_stable')[0].click()
      return
    else if $('#show_all_racers').length > 0 && (key == 'z' || key == 'r')
      if key == 'z'
        $('#show_all_racers')[0].click()
      else if $('table.all_racers').is(':visible')
        $('.default')  .toggle()
        $('.optional1').toggle()
      return

    if $('#racer_menu').length > 0 && key == 'z'
      $('#racer_menu').toggle()
      $('#race_candidates').toggle()
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

    if $('#racer_weight_fat').is(':focus') && key == '.'
      $('span.fat_to_best')[0].click()
      return false
    if $('#racer_weight_lean').is(':focus') && key == ','
      $('span.lean_to_best')[0].click()
      return false

    if $('div.all_racers').length > 0 && key != 'z'
      if '1' <= key && key <= '9'
        $('tbody tr').hide()
        $('tbody tr.age-' + key).show()
      else
        $('tbody tr').show()
      return

    key = '=' if key == '"'
    links = $('a[data-shortcut="' + key + '"]:visible')
    if links.length > 0
      links[0].click()

  $(window).on 'keydown', (e) ->
    focused = $(':focus')
    if focused.attr('name') == 'condition' && e.keyCode == 13
      focused.parent('form').submit()
      return false

  $(window).on 'keyup', (e) ->
    if e.keyCode == 27
      if $('.esc_hideable:visible').length > 0
        $('.esc_hideable:visible').hide()
      else if $('.escapeable').length > 0
        $('.escapeable')[0].click()
