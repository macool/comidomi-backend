# masonry to efficiently use vertical space
$(document).on "ready page:load", ->
  $grid = $(".auto-masonry").masonry()

  # reload masonry when images load
  $grid.imagesLoaded().progress ->
    $grid.masonry "layout"
