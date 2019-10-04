$ ->
  $('#show_retired_racers').on 'click', ->
    $(this).next('table').toggle()

  $('span.fat_to_best').on 'click', ->
    weight_fat = $(this).prev('input').val()
    $(this).parents('td').next('td').children('input').val(weight_fat - 10)

  $('span.lean_to_best').on 'click', ->
    weight_lean = $(this).next('input').val()
    $(this).parents('td').prev('td').children('input').val(weight_lean - 0 + 2)
