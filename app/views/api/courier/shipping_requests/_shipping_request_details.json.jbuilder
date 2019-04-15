json.extract!(
  shipping_request,
  :id,
  :kind,
  :kind_text,
  :status,
  :address_attributes,
  :waypoints,
  :estimated_time_mins,
  :assigned_at,
  :estimated_delivery_at,
  :estimated_dispatch_at,
  :ref_lat,
  :ref_lon
)
