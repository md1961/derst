$ ->
  if $('.ranches_show.ready_for_next_week').length > 0
    $('#top_bar').addClass('ready_for_next_week').removeClass('all_training_done')
    $('#button_to_next_week').focus()

  $('span.fat_to_best').on 'click', ->
    weight_fat = $(this).prev('input').val()
    $(this).parents('td').next('td').children('input').val(weight_fat - 10)
    $(this).parents('td').next('td').next('td').children('input').val('')

  $('span.lean_to_best').on 'click', ->
    weight_lean = $(this).next('input').val()
    $(this).parents('td').prev('td').children('input').val(weight_lean - 0 + 2)
    $(this).parents('td').prev('td').prev('td').children('input').val('')

  $('tr.racer').hover(
    ->
      id = $(this).data('racer_id')
      $('tr[data-racer_id="' + id + '"]').addClass('hover')
    ->
      id = $(this).data('racer_id')
      $('tr[data-racer_id="' + id + '"]').removeClass('hover')
  )

  $('select.condition')
    .focusin(
      ->
        id = $(this).closest('tr').data('racer_id')
        $('tr[data-racer_id="' + id + '"]').addClass('hover')
    )
    .focusout(
      ->
        id = $(this).closest('tr').data('racer_id')
        $('tr[data-racer_id="' + id + '"]').removeClass('hover')
    )

  if $('.ranches_show').length > 0
    $(window).scrollTop(9999)
