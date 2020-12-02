$ ->
  if $('#results').hasClass('ready_for_race')
    if $('#result_comment_paddock').val() == ''
      $('#result_weight').focus()
    else if $('#result_num_racers').val() == ''
      $('#result_surface_condition').focus()
    else if $('#result_direction').val() == '－'
      $('#result_direction').focus()
    else if $('#result_comment_race').val() == ''
      $('#result_comment_race').focus()
    else
      $('#result_place').focus()

  place = 16
  surface_to_hide = 'none'
  grades_to_hide = []

  filter = ->
    $('#results tbody tr').show()
    if place <= 5
      $('#results tbody tr:not(.header)').addClass('dimmed')
      for n in [1 .. place]
        $('#results tbody tr.place-' + n).removeClass('dimmed')
    else
      $('#results tbody tr:not(.header)').removeClass('dimmed')
    for grade in grades_to_hide
      $('#results tbody tr.g-' + grade).addClass('dimmed')
    $('#results tbody tr.' + surface_to_hide).addClass('dimmed')

  if $('#results').length > 0
    $(window).on 'keypress', (e) ->
      if $('input[type="text"]').is(':focus') || $('input[type="number"]').is(':focus') \
          || e.ctrlKey || $('#racer_menu').is(':visible')
        return true
      key = String.fromCharCode(e.which)
      if key == 'h'
        $('#results tbody tr.dimmed').toggle()
        $('#results tbody tr.header').toggle()
        return false
      else if '1' <= key && key <= '5'
        place = parseInt(key)
      else if key == 'g' || key == 'i'
        grades_to_hide = if key == 'g' then [3] else [2, 3]
      else if key == 't' || key == 'd'
        surface_to_hide = if key == 't' then 'dirt' else 'turf'
      else
        place = 16
        surface_to_hide = 'none'
        grades_to_hide = []
      filter()

  $('table#results form').on 'submit', ->
    $('#progress_dialog').show()

  H_COMMENT_PADDOCK_LOOKUP = {
    f: '踏み込み', g: '元気ない', h: '平行線',
    ii: 'イレ今いち', ik: 'イレ苦しい', ir: 'イレ込み',
    j: '順調',
    ki: '気合い', ku: '苦しい',
    m: 'まずまず', n: 'のんびり', o: '落着き', s: '寂しい',
    tk: '使い詰め', to: '使い詰OK',
    u: 'うるさい',
    wr: '悪くない', wn: '悪くない', wg: '悪くないが',
    y: 'よく見せるが', z: '絶好調'
  }

  $('input#result_comment_paddock').on 'input', ->
    value = H_COMMENT_PADDOCK_LOOKUP[$(this).val()]
    $(this).val(value) if value
