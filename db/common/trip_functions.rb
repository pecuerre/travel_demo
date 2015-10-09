module TripFunctions

  def create_shipping_category(shipping_attrs)
    sc = Spree::ShippingCategory.where(:name => shipping_attrs[:name]).first_or_create
    puts "ShippingCategory: #{shipping_attrs[:name]}"
    sc
  end
end