$(document).on "click", ".porttare-collapse", (e) ->
  selector = $(e.target).data("target")
  $(selector).toggle()
