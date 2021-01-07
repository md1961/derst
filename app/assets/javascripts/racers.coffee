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

    $('#handicap_load_load')
      .focusin(
        ->
          $(this).css('background-color', 'white')
      )

  LOOKUP_COMMENT_AGE2 = [
    [',', '、'  ],
    ['s', '素質、'],
    ['k', '賢い、'],
    ['c', '力強、'],
    ['j', '丈夫、'],
    ['a', '脚元、'],
  ]

  $('input#racer_comment_age2').on 'input', ->
    $input = $(this)
    $.each(LOOKUP_COMMENT_AGE2, (_, pair) ->
      oldSub = pair[0]
      newSub = pair[1]
      $input.val($input.val().replace(oldSub, newSub).replace(/、$/, ''))
    )

  LOOKUP_COMMENT_AGE3 = [
    [',' , '、'  ],
    ['sp', 'スピード、'],
    ['st', 'スタミナ、'],
    ['k' , '根性、'],
    ['j' , '丈夫、'],
    ['o' , '落着、'],
    ['n' , '難、'],
    ['h' , '早、'],
    ['b' , '晩成、'],
    ['f' , '父似'],
    ['m' , '母似'],
    ['スピード、スタミナ', 'スピ、スタ'],
  ]

  $('input#racer_comment_age3').on 'input', ->
    $input = $(this)
    $.each(LOOKUP_COMMENT_AGE3, (_, pair) ->
      oldSub = pair[0]
      newSub = pair[1]
      $input.val($input.val().replace(oldSub, newSub).replace(/、$/, ''))
    )
