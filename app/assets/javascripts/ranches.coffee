$ ->
  if $('.ranches_show.ready_for_next_week').length > 0
    $('#top_bar').addClass('ready_for_next_week').removeClass('all_training_done')
    $('#button_to_next_week').prop('disabled', false).focus()

  if $('.ranches_show').length > 0
    $('form.button_to').on 'submit', ->
      $('#progress_dialog').show()

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

  $('select.condition, input.weight')
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

  if $('table.mares').length > 0
    $('table.mares .option').hide()
    $('table.mares .default').show()

  $('.ranches_show .mares th.sortable').on 'click', ->
    $tbody = $('.ranches_show .mares tbody').eq(0)
    key = if $(this).hasClass('age') then 'age' else 'price'
    $tbody.html($tbody.children('tr').sort((tr1, tr2) ->
      value1 = parseInt($(tr1).children('td.' + key).eq(0).text())
      value2 = parseInt($(tr2).children('td.' + key).eq(0).text())
      value2 - value1
    ))
    seq_num = 1
    $.each($tbody.children('tr'), (_, tr) ->
      $(tr).children('td:first').children('a').text(seq_num)
      seq_num += 1
    )
    $.get('mare_sort_key', {key: key})

  if $('.ranches_show').length > 0
    $(window).scrollTop(9999)
