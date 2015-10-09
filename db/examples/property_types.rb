require Rails.root + "db/common/trip_functions"
include TripFunctions

property_types = [
  { name: 'Hotel Services', },
  { name: 'Hotel Features', },
  { name: 'Room Amenity', },
  { name: 'Room Feature', },
]

property_types.each do |hash|
  create_property_type(hash)
end

