$ ->
  if $('.racers_show').length > 0
    $('.for_action_edit').hide()
    $('#form_to_injure').hide()

    top    = $('#name_and_traits').offset().top
    height = $('#name_and_traits').height()
    $('#results_and_conditions').css('margin-top', top + height + 15)

    $('#cancel').on 'click', ->
      $('.for_action_edit').hide()
      $('.for_action_show').show()
      $remark = $('input#racer_remark')
      $remark.val($remark.data('orig-value'))

    $('#edit_racer').on 'click', ->
      $('.for_action_show').hide()
      $('.for_action_edit').show()
      $('input#racer_remark').focus()

    $('#show_form_to_injure').on 'click', ->
      $('#form_to_injure').toggle()
      $('input#description').focus().select()

    $('input[type="checkbox"][name="trip"]').on 'change', ->
      $('input[type="hidden"][name="trip"]').val($(this).prop('checked'))

    if $('.racers_show').eq(0).hasClass('in_stable')
      $(window).scrollTop(9999)

    $('form.button_to').not('[data-remote="true"]').on 'submit', ->
      $('#progress_dialog').show()
