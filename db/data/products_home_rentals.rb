require Rails.root + "db/common/trip_functions"
require Rails.root + "db/common/fake_functions"
include TripFunctions
include FakeFunctions
require "csv"

shipping_category = get_shipping_category
available_on = Time.now - 1.day
home_rental_product_type = get_home_rental_product_type
home_rental_calculator = get_home_rental_calculator

index = 0
hash = {}
CSV.foreach(Rails.root + "db/external/houses.csv") do |row|
  index += 1
  next if index == 1
  houses_data = get_houses_parts(row)
  next unless houses_data

  product_attrs = {
      :name => houses_data[:name],
      :price => houses_data[:price],
      :description => houses_data[:description],
      :sku => get_fake_sku('HOME'),
      :shipping_category_id => shipping_category.id,
      :available_on => available_on,
      :product_type_id => home_rental_product_type.id,
      :calculator_id => home_rental_calculator.id,
  }
  product = create_product(product_attrs)

  rate = Spree::Rate.new
  rate.variant_id = product.master.id
  rate.first_time!
  rate.save
  rate.set_persisted_option_value(:start_date, houses_data[:date])
  rate.set_persisted_option_value(:end_date, houses_data[:date])
  rate.set_persisted_option_value(:home_room, houses_data[:comfort_level])
  rate.set_persisted_option_value(:home_plan, houses_data[:plan])
  rate.set_persisted_option_value(:simple, houses_data[:simple])
  rate.set_persisted_option_value(:double, houses_data[:double])
  rate.set_persisted_option_value(:triple, houses_data[:triple])
  rate.set_persisted_option_value(:destination, houses_data[:destination])
  rate.save
end

# questions
# 1. que hacer con el precio