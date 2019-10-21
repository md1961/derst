$ ->
  $('#racer_name_sample_name').on 'input', ->
    len = $(this).val().length
    $name_length = $('#name_length')
    $name_length.text(if len == 0 then '' else len)
    if len == 1 || len > 9
      $name_length.addClass('illegal')
    else
      $name_length.removeClass('illegal')
