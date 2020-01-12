$ ->
  if $('.racers_show').length > 0
    top    = $('#name_and_traits').offset().top
    height = $('#name_and_traits').height()
    $('#results_and_conditions').css('margin-top', top + height + 15)

    $('select.condition').focus()

    $('#show_form_to_injure').on 'click', ->
      $('#form_to_injure').toggle()
      $('input#description').focus()

    $(window).scrollTop(9999)
