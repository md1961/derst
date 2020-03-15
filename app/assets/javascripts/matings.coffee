$ ->
  filter = ->
    $('.sires tbody tr').hide()

    if $('#sire_filter_is_outbreed').prop('checked')
      $('#header_score').removeClass('excellent_score_only')

    if $('#header_score').hasClass('excellent_score_only')
      $('td.excellent_score').parent('tr').show()
    else
      shows_interesting_only = $('#header_interesting').hasClass('interesting_only')
      shows_nicks_only = $('#header_nicks').hasClass('nicks_only')
      if shows_interesting_only && shows_nicks_only
        $('td.nicks').parent('tr').has('td.interesting').show()
      else if shows_nicks_only
        $('td.nicks').parent('tr').show()
      else if shows_interesting_only
        $('td.interesting').parent('tr').show()
      else
        $('.sires tbody tr').show()

     selection = $('#sire_filter_growth').val()
     values = if selection == '-' then ['早熟', '普通', '晩成'] else selection.split(',')
     values_to_hide = ['早熟', '普通', '晩成'].filter((e) => !values.includes(e))
     $.each(values_to_hide, (_, value) ->
       $('td.growth-' + value).parent('tr').hide()
     )

    $('.select_abc').each ->
      selection = $(@).val()
      values = if selection == '-' then ['A', 'B', 'C'] else selection.split('-')
      values_to_hide = ['A', 'B', 'C'].filter((e) => !values.includes(e))
      name = $(@).attr('id').replace('sire_filter_', '')
      $.each(values_to_hide, (_, value) ->
        class_name = name + '-' + value
        $('td.' + class_name).parent('tr').hide()
      )

    if $('#sire_filter_is_outbreed').prop('checked')
      $('.sires tbody td.inbreed').parent('tr').hide()
    else
      min_score = $('#sire_filter_score').val()
      $('.sires tbody td[data-score]').filter(->
        $(this).data('score') < min_score
      ).parent('tr').hide()

    $('#count_sires').text($('.sires tbody tr:visible').length)


  $('#header_score').on 'click', ->
    $(this).toggleClass('excellent_score_only')
    if $(this).hasClass('excellent_score_only')
      $('#sire_filter_score').val(20)
    filter()
    $('#sire_filter_score')[0].focus()

  $('#header_nicks').on 'click', ->
    $(this).toggleClass('nicks_only')
    filter()

  $('#header_interesting').on 'click', ->
    $(this).toggleClass('interesting_only')
    filter()

  $('#sire_filter_growth').on 'change', ->
    filter()

  $('.select_abc').on 'change', ->
    filter()

  $('#sire_filter_score').on 'input', ->
    $('#header_score').removeClass('excellent_score_only')
    filter()

  $('#sire_filter_is_outbreed').on 'change', ->
    filter()


  $('table.racer_name_candidates span.dismiss').on 'click', ->
    $(this).parents('tr').hide()
                         .nextAll('tr:hidden:first').show()
