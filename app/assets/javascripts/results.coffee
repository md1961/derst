$ ->
  if $('#results').hasClass('ready_for_race')
    if $('#result_comment_paddock').val() == ''
      $('#result_comment_paddock').focus()
    else if $('#result_surface_condition').val() == '－'
      $('#result_surface_condition').focus()
    else if $('#result_direction').val() == '－'
      $('#result_direction').focus()
    else if $('#result_comment_race').val() == ''
      $('#result_comment_race').focus()
    else
      $('#result_place').focus()
