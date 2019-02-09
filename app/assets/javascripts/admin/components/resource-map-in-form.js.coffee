class ResourceMapInForm
  constructor: (@wrapper) ->
    @$wrapper = $(@wrapper)
    @$mapPlaceholder = @$wrapper.find(".map-placeholder")
    @$resourceLatInput = @$wrapper.find "input[name*=lat]"
    @$resourceLonInput = @$wrapper.find "input[name*=lon]"
    $(document).trigger "porttare:load-maps", @mapsLoaded

  defaultCenter: ->
    lat: @$wrapper.data("default-lat"),
    lng: @$wrapper.data("default-lon")

  resourceLatLng: ->
    lat: @$resourceLatInput.val()
    lng: @$resourceLonInput.val()

  mapsLoaded: =>
    @drawMap()
    @clickListener()

  clickListener: ->
    google.maps.event.addListener @map, 'click', (event) =>
      @drawMarker(event.latLng)
      @updateResource(event.latLng)

  updateResource: (latLng) ->
    @$resourceLatInput.val latLng.lat()
    @$resourceLonInput.val latLng.lng()

  drawMap: ->
    resourceLatLng = @resourceLatLng()
    zoom = 15
    if resourceLatLng.lat && resourceLatLng.lat != ""
      mapCenter =
        lat: parseFloat(resourceLatLng.lat)
        lng: parseFloat(resourceLatLng.lng)
      @map = new google.maps.Map(@$mapPlaceholder[0],
        zoom: zoom,
        center: mapCenter
      )
      @drawMarker(mapCenter)
    else
      @map = new google.maps.Map(@$mapPlaceholder[0],
        zoom: zoom,
        center: @defaultCenter()
      )

  drawMarker: (latLng) ->
    @clearCurrentMarker()
    @map.panTo latLng
    @marker = new google.maps.Marker
      position: latLng
      map: @map

  clearCurrentMarker: ->
    @marker.setMap(null) if @marker
    @marker = null

$(document).on "ready page:load", ->
  selector = ".resource-map-in-form"
  for wrapper in $(selector)
    new ResourceMapInForm(wrapper)
