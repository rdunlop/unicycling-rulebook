toggle = ->

  toggleItem = (el) ->
    target = $(el).data 'toggle'
    $(target).toggle().toggleClass 'is--hidden is--visible'
    $(el)
      .toggleClass 'is--toggled'
      .blur()

  # ##### Toggle Items in and out of view
  $("body").on "click", ".js--toggle", ->
    toggleItem this
    $("html, body").animate
      scrollTop: $(this).offset().top - 10
    , 1000
    return

  inactive_parent = $(".js--collapsible .is--active")
    .closest '.is--hidden'
    .removeClass 'is--hidden'
    .addClass 'is--visible'
  inactive_parent.siblings 'span'
    .addClass 'is--toggled'
  inactive_parent.closest '.navSection__item'
    .addClass 'is--toggled'

$(document).ready toggle
