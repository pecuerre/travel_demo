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

	def get_piece_of_array(array)
		 (1..rand(array.length)).map { array.sample }.uniq
	end

	def get_fake_hotel_name
		"Hotel: " + Faker::Company.name
	end

	def get_fake_description
		Faker::Lorem.paragraphs(rand(5) + 1).join("<br>")
	end

	def get_fake_number(min, max)
		diff = max - min
		number = (rand(diff) + min).to_i / 5 * 5
		number
	end

	def get_fake_sku
		Faker.bothify('???-######').upcase
	end
end