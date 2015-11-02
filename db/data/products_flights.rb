require Rails.root + "db/common/trip_functions"
include TripFunctions
require "csv"

index = 0
CSV.foreach(Rails.root + "db/external/flights.csv") do |row|
  index += 1
  return if index == 1
  product_attrs = {
      :name => get_fake_hotel_name,
      :price => get_fake_number(60, 120),
      :description => get_fake_description,
      :sku => get_fake_sku,
      :shipping_category_id => shipping_category.id,
      :available_on => available_on,
      :product_type_id => hotel_product_type.id,
      :calculator_id => hotel_calculator.id,
  }
  product = create_product(product_attrs)
end
