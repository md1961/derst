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

  filter = ->
    if place <= 5
      $('#results tbody tr').addClass('dimmed')
      for n in [1 .. place]
        $('#results tbody tr.place-' + n).removeClass('dimmed')
    else
      $('#results tbody tr').removeClass('dimmed')
    $('#results tbody tr.' + surface_to_hide).addClass('dimmed')

  if $('#results').length > 0
    $(window).on 'keypress', (e) ->
      if $('input[type="text"]').is(':focus') || $('input[type="number"]').is(':focus') \
          || e.ctrlKey || $('#racer_menu').is(':visible')
        return true
      key = String.fromCharCode(e.which)
      if '1' <= key && key <= '5'
        place = parseInt(key)
      else if key == 't' || key == 'd'
        surface_to_hide = if key == 't' then 'dirt' else 'turf'
      else
        place = 16
        surface_to_hide = 'none'
      filter()
