module PriceTravel
  module Api
    class << self

      def hotels(params)
        # Prepare service url and parameters structure.
        if (params[:id])
          service = "/services/hotels/#{params[:id]}"
          params = nil
        else
          # Validated filter parameters.
          if params['search-going-to'].to_i == 0
            raise ArgumentError, 'Destination not found.'
          elsif params['search-check-in-date'].to_s == '' or params['search-check-out-date'].to_s == ''
            raise ArgumentError, 'There is not enough information to verify availability of hotels.'
          end

          service = "/services/hotels/availability"
          params = PriceTravel::Utils.prepare_for_hotels(params)
        end

        # Send request to api.pricetravel.com
        PriceTravel::HTTPService.make_request(service, params)

      rescue ArgumentError => e
        respondError(e.to_s, 404)
      rescue StandardError => e
        respondError(e.to_s, 500)
      end

      # TODO: Restructural método flights con la misma idea de hotels.
      def flights(params)
        # departure_airport = Airport.like_location_and_iata(params['search-flying-from']).first
        # return BestDay::Response.new([], ["Airport name or destination not found for #{params['search-flying-from']}."]) unless departure_airport
        #
        # arrival_airport = Airport.like_location_and_iata(params['search-flying-to']).first
        # return BestDay::Response.new([], ["Airport name or destination not found for #{params['search-flying-to']}."]) unless arrival_airport
        #
        # if not params['search-flight-type'] or params['search-flight-type'] == '' or not params['search-flying-from'] or params['search-flying-from'] == '' or not params['search-flying-to'] or params['search-flying-to'] == '' or not params['search-departing-date'] or params['search-departing-date'] == '' or (params['search-flight-type'] == 'Roundtrip' and (not params['search-returning-date'] or params['search-returning-date'] == ''))
        #   return PriceTravel::Response.new([], ['There is not enough information to verify availability of flights.'])
        # end
        #
        # p = PriceTravel::Utils.prepare_for_flights(departure_airport, arrival_airport, params)
        #
        # if SpreeTravelDemo4::Application.config.mode_offline
        #
        #   body = File.open('project/price_travel/flights.txt').readline()
        #   flights = PriceTravel::Utils.parse_flights(JSON.parse(body), params, p)
        #   # flights = Kaminari.paginate_array(flights).page(params[:page])
        #   return PriceTravel::Response.new(flights)
        #
        # else
        #
        #   begin
        #     response = PriceTravel::HTTPService.make_request('/services/flights/itineraries', p)
        #       # puts response.inspect
        #   rescue StandardError => e
        #     return BestDay::Response.new([], [e.to_s])
        #   else
        #     flights = JSON.parse(response.body)
        #   end
        #
        #   flights = PriceTravel::Utils.parse_flights(flights, params, p)
        #   # flights = Kaminari.paginate_array(flights).page(params[:page])
        #   PriceTravel::Response.new(flights)
        #
        # end
      end

      # Returns all destinations or one destination details.
      def destinations(countryId, id=false)
        service = "/services/catalogs/countries/#{countryId}" + (id ? "/destinations/#{id}" : "")
        PriceTravel::HTTPService.make_request(service)
      rescue StandardError => e
        respondError(e.to_s, 500)
      end

      # Returns object similar to 'api.pricetravel.com' response,
      # with {body: {error: '...'}, code: ### } structure.
      def respondError(msg, code)
        h = {:body => {error: msg}.to_json, :code => code}
        Struct.new(*h.keys).new(*h.values)
      end

    end
  end
end
