require Rails.root + "db/common/trip_functions"
include TripFunctions
require "csv"

shipping_category = get_shipping_category
available_on = Time.now - 1.day
flight_product_type = get_flight_product_type
flight_calculator = get_flight_calculator

index = 0

CSV.foreach(Rails.root + "db/external/flights.csv") do |row|
  index += 1
  return if index == 1
  flight_data = get_flight_parts(row)
  return if flight_data[:flight_number] == ''
  flight_name   = "#{flight_data[:flight_number]} (#{flight_data[:charter]})"
  flight_price = flight_data[:adult_price]

  product_attrs = {
      :name => flight_name,
      :price => flight_price,
      :description => flight_name,
      :sku => get_fake_sku('FLT'),
      :shipping_category_id => shipping_category.id,
      :available_on => available_on,
      :product_type_id => flight_product_type.id,
      :calculator_id => flight_calculator.id,
  }
  product = create_product(product_attrs)
end
