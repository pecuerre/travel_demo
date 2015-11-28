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
    taxon = Spree::Taxon.where(:name => taxon_attrs[:name], :taxonomy => taxonomy).first_or_create(taxon_attrs)
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

  def get_home_rental_product_type
    Spree::ProductType.where(:name => 'home_rental').first
  end

  def get_hotel_calculator
    Spree::TravelCalculator.find_by_name('Spree::CalculatorHotel')
  end

  def get_flight_calculator
    Spree::TravelCalculator.find_by_name('Spree::CalculatorFlight')
  end

  def get_home_rental_calculator
    Spree::TravelCalculator.find_by_name('Spree::CalculatorHomeRental')
  end

  def get_shipping_category
    Spree::ShippingCategory.first
  end

  #############################################################################
  ### Normalize functions
  #############################################################################

  def normalize_date(date_string)
    return nil unless date_string
    date, time = date_string.split(" ")
    hour,minute = time.split(":")
    hour = "0" + hour if hour.length == 1
    month, day, year = date.split("/")
    month = "0" + month if month.length == 1
    day = "0" + day if day.length == 1
    year = "20" + year if year.length == 2
    date_str = "#{year}-#{month}-#{day}"
    time_str = "#{hour}:#{minute}"
    final_time = "#{date_str} #{time_str}".to_time
    [final_time, final_time]
  end

  # TODO: implementar esto
  def normalize_price(price_string)
    price_string
  end

  #############################################################################
  ### Extract functions
  #############################################################################

  def get_flight_parts(row)
    date, time = normalize_date(row[2])
    hash = {
      :flight_number   => row[0],
      :charter         => row[1],
      :date            => date,
      :time            => time,
      :origin          => row[3],
      :destination     => row[4],
      :adult_price     => normalize_price(row[5]),
      :child_price     => normalize_price(row[6]),
      :infant_price    => normalize_price(row[7]),
      :included_weight => row[8],
      :suitcase_price  => row[9],
      :box_price       => row[10],
    }
    return nil unless hash[:date]
    hash
  end

  def get_houses_parts(row)
    hash = {
      :destination    => row[0], # rate.destination
      :name           => row[1], # product.name
      :description    => row[2], # product.description
      :room_count     => row[3].to_i,
      :bathrooms      => row[4].to_i,
      :type           => row[5],
      :comfort_level  => Spree::OptionType.find_by_name('home_room').option_values.find {|o| o.presentation == row[6]}, # rate.home_room
      :plan           => Spree::OptionType.find_by_name('home_plan').option_values.first.id, #row[7] # rate.plan
      :service_level  => row[8],
      :location_type  => row[9],
      :house_view     => row[10],
      :total_price    => row[11].to_i,
      :simple_price   => row[12].to_i,
      :double_price   => row[13].to_i,
      :triple_price   => row[14].to_i,
      #empty column   => row[15],
      :max_adults     => row[16].to_i,
      #empty column   => row[17],
      :provider       => row[18],
      :movility       => row[19],
      :address        => row[20],
      :municipality   => row[21],
      :email          => row[22],
      :fax            => row[23],
      :phone          => row[24],
      :web            => row[25],
      :latitude       => row[26],
      :longitude      => row[27],
      :segment        => row[28],
      #empty column   => row[29],
      :home_amenities => row[30..44],
      :room_amenities => row[45..55],
      #empty columns  => row[56..57],
      :start_date     => "2015/01/01".to_date,
      :end_date       => "2020/12/31".to_date,
    }
  end
end