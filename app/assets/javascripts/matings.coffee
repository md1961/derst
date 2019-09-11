$ ->
  $('#head_interesting').on 'click', ->
    if $(this).hasClass('interesting_only')
      $('tbody tr').show()
      $(this).removeClass('interesting_only')
    else
      $('tbody tr').hide()
      $('td.interesting').parent('tr').show()
      $(this).addClass('interesting_only')
