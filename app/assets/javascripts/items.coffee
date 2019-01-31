# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.filter-simple-button').click (e) ->
    $('.filter-simple-button').removeClass('is-active')
    e.currentTarget.classList.add('is-active')
    filter = e.currentTarget.dataset.filter
    if filter == 'rlh'
      $('tr.data').addClass('hidden')
      $('.rlh').removeClass('hidden')
    else
      $('tr.data').removeClass('hidden')

