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

  if $('#results').length > 0
    $(window).on 'keypress', (e) ->
      if $('input[type="text"]').is(':focus') || $('input[type="number"]').is(':focus') || e.ctrlKey
        return true
      key = String.fromCharCode(e.which)
      if '1' <= key && key <= '5'
        $('#results tbody tr').hide()
        for n in [1 .. parseInt(key)]
          $('#results tbody tr.place-' + n).show()
      else
        $('#results tbody tr').show()
