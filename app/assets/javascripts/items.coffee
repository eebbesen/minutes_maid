# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

filterButton = () ->
  document.getElementsByClassName('filter-simple-button')
    .click(() ->
       val = this.attribute('data-filter')
       if val == 'all'
          document.getElementsByClassName('item-row').forEach((i) ->
             i.classList.remove('hidden')
          )
       else
          document.getElementByClassName('item-row').forEach((i) ->
            if i.classList.contains(val)
              i.classList.remove('hidden')
            else
              i.classList.add('hidden')
            end
          )
       end
       )