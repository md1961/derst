$ ->
  $('#names').on 'focus', ->
    $(this).select()

  $('#names').on 'input', ->
    len = $(this).val().length
    $name_length = $('#name_length')
    $name_length.text(if len == 0 then '' else len)
    if len == 1 || len > 9
      $name_length.addClass('illegal')
    else
      $name_length.removeClass('illegal')


  dragStartHandler = (e) ->
    e.dataTransfer.setData('text/plain', e.target.id)
    $(this).addClass('dragging')

  dragEndHandler = (e) ->
    $(this).removeClass('dragging')

  dragOverHandler = (e) ->
    if e.preventDefault
      e.preventDefault()
    $(this).addClass('over')
    return false

  dragEnterHandler = (e) ->
    if e.preventDefault
      e.preventDefault()
    $(this).addClass('over')

  dragLeaveHandler = (e) ->
    $(this).removeClass('over')

  dropHandler = (e) ->
    if e.stopPropagation
      e.stopPropagation()
    $(this).removeClass('over')
    nameSampleId = e.dataTransfer.getData('text').replace('name_sample-', '')
    item_name = $(this).data('item_name')
    urlDest = '/racer_name_samples/' + nameSampleId + '/update_enum_item?item_name=' + item_name
    window.location.replace(urlDest)
    return false

  for $name_sample in $('td.name_sample')
    $name_sample.addEventListener('dragstart', dragStartHandler, false)
    $name_sample.addEventListener('dragend'  , dragEndHandler  , false)

  for $dropTarget in $('div.racer_name_samples_table_grouped')
    $dropTarget.addEventListener('dragover' , dragOverHandler , false)
    $dropTarget.addEventListener('dragenter', dragEnterHandler, false)
    $dropTarget.addEventListener('dragleave', dragLeaveHandler, false)
    $dropTarget.addEventListener('drop'     , dropHandler     , false)
