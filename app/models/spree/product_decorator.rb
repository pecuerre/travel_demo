Spree::Product.class_eval do 

	def self.with_property(property)
		joins(:product_properties => :property).where('spree_properties.id' => property.id)
	end

	def self.with_property_type(property_type)
		joins(:product_properties => {:property => :property_type}).where('spree_property_types.id' => property_type.id)
	end
end