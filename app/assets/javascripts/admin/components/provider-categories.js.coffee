wrapper = ".provider-categories-collection"
selector = ".resource .img-responsive"
classToToggle = "img-responsive--expanded"

$(document).on "click", "#{wrapper} #{selector}", (e) ->
  $target = $(e.currentTarget)
  $target.toggleClass classToToggle

  # reload masonry after css transition
  setTimeout(->
    $(".auto-masonry").masonry()
  , 90)
