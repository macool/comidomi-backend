widthCalculator = null

class AffixWidthCalculator
  constructor: ($sidebar, $affix) ->
    @$affix = $affix
    @$sidebar = $sidebar

  apply: ->
    width = @$sidebar.outerWidth()
    @$affix.css("width", width)

$(document).on "ready page:load", ->
  $mainSidebar = $("#main-sidebar")
  $affix = $mainSidebar.find("#affix")
  $affix.affix offset: { top: 60 } # apply affix
  widthCalculator = new AffixWidthCalculator $mainSidebar, $affix
  widthCalculator.apply()

$(window).on "resize orientationchange", ->
  widthCalculator.apply()
