$ ->
  $('#racer_name_sample_name').on 'input', ->
    len = $(this).val().length
    $('#name_length').text(if len == 0 then '' else len)
