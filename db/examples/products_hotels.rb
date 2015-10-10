require Rails.root + "db/common/trip_functions"
require Rails.root + "db/common/fake_functions"
include TripFunctions
include FakeFunctions

### Configuration Variables
amount_of_fake_products = 20 
available_on = Time.now - 1.day

### Some Global Variables
place_taxonomy = get_place_taxonomy
places = get_places_array
shipping_category = get_shipping_category
properties = get_properties_array
hotel_product_type = get_hotel_product_type
hotel_calculator = get_hotel_calculator

### Destroying Products
hotels = Spree::Product.where(:product_type => Spree::ProductType.find_by_name('hotel')).destroy_all

### Creating Products
amount_of_fake_products.times do
  the_properties = (1..rand(properties.length)).map { properties.sample }.uniq
  the_taxons = [place_taxons.sample, category_taxons.sample]
  the_name = "Hotel: " + Faker::Company.name
  the_price = (rand(100) + 20).to_i / 5 * 5
  the_description = Faker::Lorem.paragraphs(rand(5) + 1).join("<br>")
  the_sku = Faker.bothify('???-######').upcase
  product_attrs = {
    :name => the_name,
    :price => the_price,
    :description => the_description,
    :sku => the_sku,
    :shipping_category_id => shipping_category.id,
    :available_on => available_on,
    :product_type_id => product_type.id,
    :calculator_id => hotel_calculator.id,
  }
  product = Spree::TravelSample.create_product(product_attrs)

  the_properties.each do |property|
    product_properties_attrs = {
      :product_id => product.id,
      :property_id => property.id,
      :value => 'yes'
    }
    Spree::TravelSample.create_product_properties(product_properties_attrs)
  end
  product.taxons = the_taxons
  product.generate_variants
end

