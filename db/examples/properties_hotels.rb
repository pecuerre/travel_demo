require Rails.root + "db/common/trip_functions"
include TripFunctions

properties = {
  'Hotel Services' => {
    'breakfast' => 'Breakfast',
    'lunch' => 'Lunch & Dinner',
    'taxi' => 'Taxi',
    'laundry' => 'Laundry',
    'massage' => 'Massages',
    'internet' => 'Internet Access',
    'wifi' => 'Wifi',
    'phone' => 'Phone Available'
  },
  'Hotel Features' => {
    'multilingual' => 'Multilingual Staff',
    'satellite' => 'Satellite TV',
    'dvd' => 'DVD Player',
    'air' => 'Air Conditioner',
    'parking' => 'Parking',
    'crib' => 'Crib',
    'minibar' => 'Fridge',
    'hair' => 'Hair Dryer',
    'towel' => 'Pool Towels',
    'safe' => 'Safe',
    'sauna' => 'Sauna',
    '24h' => '24 Hours Service',
    'room_service' => 'Room Service',
    'pool' => 'Pool',
    'elevator' => 'Elevator',
    'handicap' => 'Room for Handicapped',
    'terrace' => 'Terrace',
    'sea_view' => 'Sea View',
    'children' => 'Children are welcome',
    'cooking' => 'Cooking Facility',
    'tv' => 'TV (national channels)',
    'pets' => 'Family has Pets',
    'jacuzzi' => 'Jacuzzi',
    'coffee' => 'Coffee Maker',
  },
}

properties.keys.each do |type|
  pt = Spree::PropertyType.find_by_name(type) rescue nil
  hash = properties[type]
  hash.each do |key, value|
    property_hash = { :name => key, :presentation => value, :property_type => pt }
    prop = create_property(property_hash)
  end
end

