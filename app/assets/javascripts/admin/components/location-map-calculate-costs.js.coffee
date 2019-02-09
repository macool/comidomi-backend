class ShippingCostCalculator
  constructor: (@options) ->
    @calculate()

  calculate: ->
    data = @getPlaceAttrs()
    data.lat =  @options.latLng.lat()
    data.lon = @options.latLng.lng()
    $.post(
      "shipping_costs/calculate",
      data,
      @didCalculate
    )

  getPlaceAttrs: ->
    $("form.edit_place").serializeArray().reduce((memo, attr) ->
      if attr.name != "_method"
        memo[attr.name] = attr.value
      memo
    , {})

  didCalculate: (r) =>
    @options.callback(r)

$(document).on(
  "porttare:calculate-shipping-costs",
  (e, options) ->
    new ShippingCostCalculator(options)
)
