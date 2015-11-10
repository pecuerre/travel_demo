require Rails.root + "db/common/trip_functions"
require Rails.root + "db/common/fake_functions"
include TripFunctions
include FakeFunctions
require "csv"

shipping_category = get_shipping_category
available_on = Time.now - 1.day
flight_product_type = get_flight_product_type
flight_calculator = get_flight_calculator

index = 0
hash = {}

CSV.foreach(Rails.root + "db/external/flights.csv") do |row|
  index += 1
  next if index == 1
  flight_data = get_flight_parts(row)
  next unless flight_data
  #next if flight_data[:flight_number].to_s == ''
  # flight_name = "#{flight_data[:flight_number]} (#{flight_data[:charter]})"
  flight_name = flight_data[:flight_number]
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

  rate = Spree::Rate.new
  rate.variant_id = product.master.id
  rate.first_time!
  rate.save
  rate.set_persisted_option_value(:start_date, flight_data[:date])
  rate.set_persisted_option_value(:end_date, flight_data[:date])
  rate.set_persisted_option_value(:take_off_time, flight_data[:time])
  rate.set_persisted_option_value(:landing_time, flight_data[:date] + 150.minutes)
  rate.set_persisted_option_value(:origin, flight_data[:origin])
  rate.set_persisted_option_value(:destination, flight_data[:destination])
  rate.set_persisted_option_value(:one_adult, flight_data[:adult_price])
  rate.set_persisted_option_value(:one_child, flight_data[:child_price])
  rate.set_persisted_option_value(:one_infant, flight_data[:infant_price])
  rate.save
end

