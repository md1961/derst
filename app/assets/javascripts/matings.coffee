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

    min_fee = $('#sire_filter_fee').val()
    $('.sires tbody tr').filter(->
      $(this).data('fee') < min_fee
    ).hide()

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

    $('.sires tbody tr').filter(->
      $(this).data('fee') >= 1000
    ).show()

    $('#count_sires').text($('.sires tbody tr:visible').length)


  $('#header_score').on 'click', ->
    $(this).toggleClass('excellent_score_only')
    value = if $(this).hasClass('excellent_score_only') then 20 else ''
    $('#sire_filter_score').val(value)
    filter()
    $('#sire_filter_score')[0].focus()

  $('#header_nicks').on 'click', ->
    $(this).toggleClass('nicks_only')
    filter()

  $('#header_interesting').on 'click', ->
    $(this).toggleClass('interesting_only')
    filter()

  $('#sire_filter_fee').on 'input', ->
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


  $('#header_score').click()


  racer_name_candidates_to_reject = []

  $('table.racer_name_candidates span.dismiss').on 'click', ->
    mare_id = $(this).data('mare_id')
    sire_id = $(this).data('sire_id')
    names_for_candidates = $(this).data('names_for_candidates')
    sex = $(this).data('sex')
    name = $(this).closest('td').next('td.name').text()
    racer_name_candidates_to_reject.push(name)
    params = {
      mare_id: mare_id,
      sire_id: sire_id,
      names_for_candidates: names_for_candidates,
      sex: sex,
      names_to_reject: racer_name_candidates_to_reject.join(',')
    }
    $.get('/matings/update_racer_name_candidates', params)
