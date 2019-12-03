$ ->
  if $('#results').hasClass('ready_for_race')
    if $('#result_comment_paddock').val() == ''
      $('#result_weight').focus()
    else if $('#result_surface_condition').val() == '－'
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
      $('#results tbody tr').addClass('dimmed')
      for n in [1 .. place]
        $('#results tbody tr.place-' + n).removeClass('dimmed')
    else
      $('#results tbody tr').removeClass('dimmed')
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
