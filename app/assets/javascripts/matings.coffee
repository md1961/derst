$ ->
  $('#head_interesting').on 'click', ->
    if $(this).hasClass('interesting_only')
      $('tbody tr').show()
      $(this).removeClass('interesting_only')
    else
      $('tbody tr').hide()
      $('td.interesting').parent('tr').show()
      $(this).addClass('interesting_only')

  $(window).on 'keydown', (e) ->
    if e.ctrlKey
      return
    key = String.fromCharCode(e.which).toLowerCase()
    if key == 'k'
      $('#to_prev_mating')[0].click()
    else if key == 'j'
      $('#to_next_mating')[0].click()
