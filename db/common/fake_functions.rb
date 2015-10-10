module FakeFunctions

	def get_place_taxonomy
		Spree::Taxonomy.where(:name => 'Destination').first
	end

	def get_places_array
		place_taxons = Spree::Taxon.where(:taxonomy_id => place_taxonomy.id).to_a
		place_taxons.shift
		place_taxons
	end

	def get_shipping_category
		Spree::ShippingCategory.first
	end

	def get_properties_array
		Spree::Property.all.to_a
	end

	def get_hotel_product_type
		Spree::ProductType.where(:name => 'hotel').first
	end

	def get_hotel_calculator
		Spree::TravelCalculator.find_by_name('Spree::CalculatorHotel')
	end
end