$ ->
  $('#show_retired_racers').on 'click', ->
    $(this).next('table').toggle()
