module TripFunctions

  #############################################################################
  ### Create functions
  #############################################################################

  def create_shipping_category(shipping_attrs)
    shipping_category = Spree::ShippingCategory.where(:name => shipping_attrs[:name]).first_or_create
    puts "ShippingCategory: #{shipping_attrs[:name]}"
    shipping_category
  end

  def create_taxonomy(taxonomy_attrs)
    taxonomy = Spree::Taxonomy.where(:name => taxonomy_attrs[:name]).first_or_create(taxonomy_attrs)
    puts "Taxonomy: #{taxonomy_attrs[:name]}"
    taxonomy
  end

  def create_taxon(taxonomy, taxon_attrs)
    taxon_attrs[:parent] = Spree::Taxon.where(:name => taxon_attrs[:parent]).first if taxon_attrs[:parent]
    taxon_attrs[:taxonomy] = taxonomy
    taxon = Spree::Taxon.where(:name => taxon_attrs[:name]).first_or_create(taxon_attrs)
    puts "Taxon: #{taxon_attrs[:name]}"
    taxon
  end

  def create_property_type(property_type_attrs)
    property = Spree::PropertyType.where(:name => property_type_attrs[:name]).first_or_create(property_type_attrs)
    puts "Property Type: #{property_type_attrs[:name]}"
    property
  end

  def create_property(property_attrs)
    property = Spree::Property.where(:name => property_attrs[:name]).first_or_create(property_attrs)
    puts "Property: #{property_attrs[:name]}"
    property
  end

  def create_product(product_attrs)
  	product = Spree::Product.where(:name => product_attrs[:name]).first_or_create(product_attrs)
  	puts "Product: #{product_attrs[:name]}"
  	product
  end

  def create_product_properties(product_properties_attrs)
    pp = Spree::ProductProperty.create(product_properties_attrs)
    puts "  - ProductProperty: #{Spree::Property.find(product_properties_attrs[:property_id]).name}"
    pp
  end

  #############################################################################
  ### Get functions
  #############################################################################

  def get_hotel_product_type
    Spree::ProductType.where(:name => 'hotel').first
  end

  def get_flight_product_type
    Spree::ProductType.where(:name => 'flight').first
  end

  def get_hotel_calculator
    Spree::TravelCalculator.find_by_name('Spree::CalculatorHotel')
  end

  def get_flight_calculator
    Spree::TravelCalculator.find_by_name('Spree::CalculatorFlight')
  end

  #############################################################################
  ### Normalize functions
  #############################################################################

  def normalize_date(date_string)
    month, day, year = date_string.split("/")
    month = "0" + month if month.length == 1
    day = "0" + day if day.length == 1
    year = "20" + year if year.length == 2
    "#{year}-#{month}-#{day}".to_date
  end

  # TODO: implementar esto
  def normalize_price(price_string)
    price_string
  end

  #############################################################################
  ### Extract functions
  #############################################################################

  def get_flight_parts(csv_row)
    {
      :flight_number   => row[0],
      :charter         => row[1],
      :date            => normalize_date(row[2]),
      :origin          => row[3],
      :destination     => row[4],
      :adult_price     => normalize_price(row[5]),
      :child_price     => normalize_price(row[6]),
      :infant_price    => normalize_price(row[7]),
      :included_weight => row[8],
      :suitcase_price  => row[9],
      :box_price       => row[10],
    }
  end

end