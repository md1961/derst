$ ->
  if $('.racers_show').length > 0
    $('.for_action_edit').hide()
    $('#form_to_injure').hide()

    top    = $('#name_and_traits').offset().top
    height = $('#name_and_traits').height()
    $('#results_and_conditions').css('margin-top', top + height + 15)

    $('#edit_racer, #cancel').on 'click', ->
      return if $('#results input').is(':focus')
      $('.for_action_show').toggle()
      $('.for_action_edit').toggle()
      if $('input#racer_weight_fat').length > 0
        $('input#racer_weight_fat').focus()
      else
        $('input#racer_remark').focus()

    $('#show_form_to_injure').on 'click', ->
      $('#form_to_injure').toggle()
      $('input#description').focus()

    $('input[type="checkbox"][name="trip"]').on 'change', ->
      $('input[type="hidden"][name="trip"]').val($(this).prop('checked'))

    if $('.racers_show').eq(0).hasClass('in_stable')
      $(window).scrollTop(9999)

    $('form.button_to').not('[data-remote="true"]').on 'submit', ->
      $('#progress_dialog').show()
