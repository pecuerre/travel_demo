module SpreeApi
  class Api
    
    def initialize
      @countries = {}
    end

    def hotels(params)
        destination = Destination.like_name(params['search-going-to']).first
        return SpreeApi::Response.new([], ['Destination not found.']) unless destination

        if not params['search-going-to'] or params['search-going-to'] == '' or not params['search-check-in-date'] or params['search-check-in-date'] == '' or not params['search-check-out-date'] or params['search-check-out-date'] == ''
          return SpreeApi::Response.new([], ['There is not enough information to verify availability of hotels.'])
        end

        p = SpreeApi::Utils.prepare_for_hotels(destination.price_travel_id, params)

        begin
          response = PriceTravel::HTTPService.make_request('/services/hotels/availability', p)
        rescue StandardError => e
          return BestDay::Response.new([], [e.to_s])
        else
          body = JSON.parse(response.body)
          hotels = PriceTravel::Utils.parse_hotels(body, params, p)
        end

        PriceTravel::Response.new(hotels)

      end

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
