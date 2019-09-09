$(document).on 'turbolinks:load', ->
  $('#button_to_show_sire_filter').on 'click', ->
    $('#sire_filter').show()
    $(this).hide()
