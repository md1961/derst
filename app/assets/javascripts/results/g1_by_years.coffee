$ ->
  $('div.results_g1_by_years_show td').on 'click', ->
    if $('#marker').hasClass('filtered')
      $('span.racers').hide()
      $('span.places').show()
      $('th').show()
      $('td').show()

      $('td').css('width', '6.0rem')
      $('td').css('font-weight', 'normal')

      $('#marker').removeClass('filtered')
    else
      race_id = $(this).data('race-id')

      $('th:not(.race-' + race_id + ')').hide()
      $('td:not(.race-' + race_id + ')').hide()

      $('th.year').show()
      $tds = $('td.race-' + race_id)
      $tds.find('span.places').hide()
      $tds.find('span.racers').show()

      $('td').css('width', 'auto')
      $(this).css('font-weight', 'bold')

      $('#marker').addClass('filtered')
