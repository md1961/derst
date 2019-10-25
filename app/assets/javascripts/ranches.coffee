$ ->
  if $('.ranches_show.ready_for_next_week').length > 0
    next_month_week = $('.ranches_show.ready_for_next_week').eq(0).data('next_month_week')
    month = next_month_week[0]
    week  = next_month_week[1]
    $('#top_bar').addClass('ready_for_next_week')
    $('#button_to_next_week').focus()

  $('#show_all_racers').on 'click', ->
    $(this).next('table').toggle()
    $('.racers').toggle()

  $('span.fat_to_best').on 'click', ->
    weight_fat = $(this).prev('input').val()
    $(this).parents('td').next('td').children('input').val(weight_fat - 10)

  $('span.lean_to_best').on 'click', ->
    weight_lean = $(this).next('input').val()
    $(this).parents('td').prev('td').children('input').val(weight_lean - 0 + 2)

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
