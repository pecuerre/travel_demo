Spree::Product.class_eval do 

  def self.with_property(property)
    with_property_id(property.id)
  end

  def self.with_property_id(property_id)
    joins(:product_properties => :property).where('spree_properties.id' => property_id)
  end

  def self.with_property_ids(ids)
    list = self.where('1 > 0')
    ids.each do |pid|
      list = list.with_property_id(pid)
    end
    list
  end

  def self.with_option_value(option_type_name, option_value, operator = "=")
    string = "spree_rate_option_values.value #{operator} ?"
    temporal = joins(:rates => {:option_values => :option_value})
    temporal = temporal.where('spree_option_values.name' => option_type_name)
    temporal = temporal.where(string, option_value)
    temporal
  end

  def self.with_property_type(property_type)
    joins(:product_properties => {:property => :property_type}).where('spree_property_types.id' => property_type.id)
  end

  def self.with_product_type_name(product_type_name)
    product_type = Spree::ProductType.where(:name => product_type_name).first
    with_product_type(product_type)
  end

  def self.with_product_type(product_type)
    where(:product_type_id => product_type.id)
  end

  def self.hotels
    with_product_type_name('hotel')
  end

  def self.flights
    with_product_type_name('flight')
  end

  def ransackable_attributes(auth_object = nil)
    ['name', 'slug', 'description']
  end
end