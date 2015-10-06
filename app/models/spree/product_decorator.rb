Spree::Product.class_eval do 

	def self.with_property(property)
		joins(:product_properties => :property).where('spree_properties.id' => property.id)
	end
end