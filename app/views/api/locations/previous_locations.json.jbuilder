json.previous_locations @previous_locations do |location|
  json.lat location.lat
  json.lon location.lon
end

json.meta do
  json.new_location @is_new_location
end
