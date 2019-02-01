# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $('#item-filter').change () ->
    sel = $('#item-filter option:selected').attr('value')
    if sel == 'all'
      $('tr.data').removeClass('hidden')
    else
      $('tr.data').addClass('hidden')
      $('.' + sel).removeClass('hidden')

