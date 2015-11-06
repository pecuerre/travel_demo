require Rails.root + "db/common/trip_functions"
require Rails.root + "db/common/fake_functions"
include TripFunctions
include FakeFunctions

### Configuration Variables
amount_of_fake_products = 10 
available_on = Time.now - 1.day

### Some Global Variables
places = get_places_array
shipping_category = get_shipping_category
properties = get_properties_array
hotel_product_type = get_hotel_product_type
hotel_calculator = get_hotel_calculator

### Creating Products
amount_of_fake_products.times do
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

  get_piece_of_array(properties).each do |property|
    product_properties_attrs = {
      :product_id => product.id,
      :property_id => property.id,
      :value => 'yes'
    }
    create_product_properties(product_properties_attrs)
  end
  product.taxons = [places.sample]
  product.generate_variants
end

