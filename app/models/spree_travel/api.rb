module SpreeTravel
  class Api
    
    def initialize
      @countries = {}
    end

    def hotels(params)
      destination = Spree::Taxon.where('name LIKE ?', params['search-going-to']).first

      # return SpreeTravel::Response.empty_destination unless destination
      # return SpreeTravel::Response.not_enough_info_for_hotels unless SpreeTravel::Utils.params_for_hotels?(params)

      products = Spree::Product.hotels
      # taxons = [destination]
      # products = products.in_taxons(taxons)

      # TODO: aqui va toda la logica de filtrar por los params
      # params['search-check-in-date']
      # params['search-check-out-date']
      # params['search-rooms']
      # params['search-adults']
      # params['search-kids']

      # NOTE: este es un codigo que me dio el migue para filtrar por option types
      # ov_adult = Spree::OptionType.find_by(name: 'adult').option_values.first.id
      # rates = Spree::Rate.includes(:option_values).where(spree_rate_option_values: {option_value_id: ov_adult})
      # Spree::Variant.includes(:rates).where(spree_rates: {id: rates.ids})

      # property_ids = get_properties_ids_from_params
      # products = products.with_property_ids(property_ids)
      # products = products.order(params[:sort]) if params[:sort]

      hotels = SpreeTravel::Utils.parse_hotels(products, params)
      SpreeTravel::Response.new(hotels)
    end

    def flights(params)
      departure_airport = Spree::RateOptionValue.where('value LIKE ?', params['search-flying-from']).first
      arrival_airport = Spree::RateOptionValue.where('value LIKE ?', params['search-flying-to']).first

      # return SpreeTravel::Response.invalid_airport unless departure_airport
      # return SpreeTravel::Response.invalid_airport unless arrival_airport
      # return SpreeTravel::Response.not_enough_info_for_flights unless SpreeTravel::Utils.params_for_flights?(params)

      products = Spree::Product.flights
      flights = SpreeTravel::Utils.parse_flights(products, params)
      SpreeTravel::Response.new(flights)
    end

    def house(params)
      p = SpreeTravel::Utils.prepare_for_house(params)
      uri = "/house/#{params[:id]}/show.json"
      begin
        response = SpreeTravel::HTTPService.make_request(uri, p)
      rescue StandardError => e
        return SpreeTravel::Response.new([], [e.to_s])
      else
        house = JSON.parse(response.body)
      end

      house = SpreeTravel::Utils.parse_house(house, params, p)
      SpreeTravel::Response.new(house)

    end

    def houses(params)
      p = SpreeTravel::Utils.prepare_for_houses(params)
      begin
        #response = SpreeTravel::HTTPService.make_request('request.json', p)
        response = SpreeTravel::HTTPService.make_request('houses.json', p)
        rescue StandardError => e
          return SpreeTravel::Response.new([], [e.to_s])
        else
          houses = JSON.parse(response.body)
        end

        houses = SpreeTravel::Utils.parse_houses(houses, params, p)
        # flights = Kaminari.paginate_array(flights).page(params[:page])
        SpreeTravel::Response.new(houses)
      end
   end
end
