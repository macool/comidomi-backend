class LocationMapShippingCosts
  constructor: (@el) ->
    @$el = $(@el)
    @initialCenter = {
      lat: @$el.data("lat"),
      lng: @$el.data("lon")
    }
    @load()

  load: ->
    $(document).trigger "porttare:load-maps", @mapsLoaded

  mapsLoaded: =>
    @drawMap()
    @clickListener()
    @formListener()

  formListener: ->
    wrapper = ".shipping-costs-observing-inputs"
    $("#{wrapper} input").on "change", @performCalc

  drawMap: ->
    @map = new google.maps.Map(@el,
      zoom: 13,
      center: @initialCenter
    )

  clickListener: ->
    google.maps.event.addListener @map, 'click', (event) =>
      @drawMarker(event.latLng)
      @performCalc()
      @addPolyline(event.latLng)

  addPolyline: (latLng) ->
    @clearCurrentLinePath()
    @linePath = new google.maps.Polyline
      path: [
        @initialCenter,
        latLng
      ]
      geodesic: true
    @linePath.setMap(@map)

  clearCurrentLinePath: ->
    @linePath.setMap(null) if @linePath

  drawMarker: (latLng) ->
    @clearCurrentMarker()
    @marker = new google.maps.Marker
      position: latLng,
      map: @map

  clearCurrentMarker: ->
    @marker.setMap(null) if @marker

  performCalc: =>
    $(document).trigger(
      "porttare:calculate-shipping-costs",
      latLng: @marker.getPosition()
      callback: @shippingCalculated
    )
    @calculatingUi()

  shippingCalculated: (results) ->
    $(".calculating").addClass "hidden"
    $results = $(".shipping-costs-results")
    $results.removeClass "hidden"
    $results.find(".distance .value").html(
      results.distance.toFixed(4)
    )
    $results.find(".price .value").html(
      results.price.toFixed(3)
    )
    $results.find(".price_per_km .value").html(
      results.price_per_km.toFixed(3)
    )
    $results.find(".extra_price_per_km .value").html(
      results.extra_price_per_km.toFixed(3)
    )
    $results.find(".shipping_fare .value").html(
      results.shipping_fare.toFixed(2)
    )

  calculatingUi: ->
    $(".calulculations-intro").addClass "hidden"
    $(".shipping-costs-results").addClass "hidden"
    $(".calculating").removeClass "hidden"

$(document).on "ready page:load", ->
  selector = ".initialize-location-map-placeholder"
  for el in $(selector)
    new LocationMapShippingCosts(el)
