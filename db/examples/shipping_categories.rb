require Rails.root + "db/common/trip_functions"
include TripFunctions

shipping_attrs = [
  {:name => 'Default'}
]

for attrs in shipping_attrs
  create_shipping_category(attrs)
end
