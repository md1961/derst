$ ->
  filter = ->
    $('.sires tbody tr').hide()

    if $('#header_score').hasClass('excellent_score_only')
      $('td.excellent_score').parent('tr').show()
    else
      shows_interesting_only = $('#header_interesting').hasClass('interesting_only')
      shows_nicks_only = $('#header_nicks').hasClass('nicks_only')
      if shows_interesting_only && shows_nicks_only
        $('td.nicks')      .parent('tr').show()
        $('td.interesting').parent('tr').show()
      else if shows_nicks_only
        $('td.nicks').parent('tr').show()
      else if shows_interesting_only
        $('td.interesting').parent('tr').show()
      else
        $('.sires tbody tr').show()

     $select_growth = $('#sire_filter_growth')
     selection = $select_growth.val()
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

    $('#count_sires').text($('.sires tbody tr:visible').length)


  $('#header_score').on 'click', ->
    $(this).toggleClass('excellent_score_only')
    filter()

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
