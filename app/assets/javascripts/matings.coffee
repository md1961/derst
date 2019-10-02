$ ->
  $('#head_interesting').on 'click', ->
    parent_tr = $(this).parent()
    if parent_tr.hasClass('interesting_only')
      $('tbody tr').show()
      parent_tr.removeClass('interesting_only')
    else
      $('tbody tr').hide()
      $('td.interesting').parent('tr').show()
      parent_tr.addClass('interesting_only')
