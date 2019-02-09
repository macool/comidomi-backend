initialize = ->
  $("[disabled]").on "click", -> false

$(document).on "ready page:load", initialize
