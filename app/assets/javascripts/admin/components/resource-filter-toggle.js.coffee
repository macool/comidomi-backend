togglerSelector = ".resource-filter-toggler"
formSelector = ".resource-filters-form"

$(document).on "click", togglerSelector, (e) ->
  $(e.target).remove()
  $(formSelector).removeClass "hidden"
