module SpreeTravel
  class Api
    
    def initialize
      @countries = {}
    end

    def hotels(params)
      destination = Spree::Taxon.where('name LIKE ?', params['search-going-to']).first

      #return SpreeTravel::Response.empty_destination unless destination
      #return SpreeTravel::Response.not_enough_info unless SpreeTravel::Utils.availability_params_present?(params)

      taxons = [destination]
      products = Spree::Product.hotels
      # products = products.in_taxons(taxons)

      # TODO: aqui va toda la logica de filtrar por los params
      # params['search-check-in-date']
      # params['search-check-out-date']
      # params['search-rooms']
      # params['search-adults']
      # params['search-kids']

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

        departure_airport = Airport.like_location_and_iata(params['search-flying-from']).first
        return BestDay::Response.new([], ["Airport name or destination not found for #{params['search-flying-from']}."]) unless departure_airport

        arrival_airport = Airport.like_location_and_iata(params['search-flying-to']).first
        return BestDay::Response.new([], ["Airport name or destination not found for #{params['search-flying-to']}."]) unless arrival_airport

        if not params['search-flight-type'] or params['search-flight-type'] == '' or not params['search-flying-from'] or params['search-flying-from'] == '' or not params['search-flying-to'] or params['search-flying-to'] == '' or not params['search-departing-date'] or params['search-departing-date'] == '' or (params['search-flight-type'] == 'Roundtrip' and (not params['search-returning-date'] or params['search-returning-date'] == ''))
          return PriceTravel::Response.new([], ['There is not enough information to verify availability of flights.'])
        end

        p = PriceTravel::Utils.prepare_for_flights(departure_airport, arrival_airport, params)
        
      if SpreeTravelDemo4::Application.config.mode_offline

        body = File.open('project/price_travel/flights.txt').readline()
        flights = PriceTravel::Utils.parse_flights(JSON.parse(body), params, p)
        # flights = Kaminari.paginate_array(flights).page(params[:page])
        return PriceTravel::Response.new(flights)

      else

        begin
          response = PriceTravel::HTTPService.make_request('/services/flights/itineraries', p)
          # puts response.inspect
        rescue StandardError => e
          return BestDay::Response.new([], [e.to_s])
        else
          flights = JSON.parse(response.body)
        end

        flights = PriceTravel::Utils.parse_flights(flights, params, p)
        # flights = Kaminari.paginate_array(flights).page(params[:page])
        PriceTravel::Response.new(flights)

      end
    end


  end
end
