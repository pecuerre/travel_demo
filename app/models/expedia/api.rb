module Expedia
  # All method naming is done in correspondence with Expedia services and ruby conventions
  class Api

    def hotels(params)
      if SpreeTravelDemo4::Application.config.mode_offline
        #body = File.open('project/match/acapulco_expedia.txt').readline()
        body = File.open('project/match/cancun_expedia.txt').readline()
        #body = File.open('project/match/ciudad_mexico_expedia.txt').readline()
        hotels = Expedia::Utils.parse_hotels(JSON.parse(body))
        return Master::Response.new(hotels)
      end

      if not params['search-going-to'] or params['search-going-to'] == '' #or not params['search-check-in-date'] or params['search-check-in-date'] == '' or not params['search-check-out-date'] or params['search-check-out-date'] == ''
        return Master::Response.new([], ['There is not enough information to verify availability of hotels.'])
      end
      p = Expedia::Utils.prepare_for_hotels(params)
      response = get_list(p)

      if response.is_a?(Expedia::Errors::APIError)
        if response.is_a?(Expedia::Errors::MultipleDestinationsFound)
          destination_id = response.destinations.select{|d|d['countryCode']=='MX'}.first['destinationId']
          p.delete('destinationString')
          p['destinationId'] = destination_id
          response = get_list(p)
        else
          return Master::Response.new([], [response.presentation_message])
        end
      end
      resources = []
      if response.body['HotelListResponse']
        resources = response.body['HotelListResponse']['HotelList']['HotelSummary']
      end
      hotels = Expedia::Utils.parse_hotels(resources)
      Master::Response.new(hotels)
    end

    # @param args [Hash] All the params required for 'get_list' call
    # @return [Expedia::HTTPService::Response] on success. A response object representing the results from Expedia
    # @return [Expedia::APIError] on Error.
    # @note A POST request is made instead of GET if 'numberOfResults' > 200
    def get_list(args)
      no_of_results = 'numberOfResults'
      method = (args[no_of_results.to_sym].to_i > 200 || args[no_of_results].to_i > 200) ||
        args[no_of_results.downcase.to_sym].to_i > 200 || args[no_of_results.downcase].to_i > 200 ? :post : :get
      services('/ean-services/rs/hotel/v3/list', args, method)
    end

    def geo_search(args)
      services('/ean-services/rs/hotel/v3/geoSearch', args)
    end

    def get_availability(args)
      services('/ean-services/rs/hotel/v3/avail', args)
    end

    def get_room_images(args)
      services('/ean-services/rs/hotel/v3/roomImages', args)
    end

    def get_information(args)
      services('/ean-services/rs/hotel/v3/info', args)
    end

    def get_rules(args)
      services('/ean-services/rs/hotel/v3/rules', args)
    end

    def get_itinerary(args)
      services('/ean-services/rs/hotel/v3/itin', args)
    end

    def get_alternate_properties(args)
      services('/ean-services/rs/hotel/v3/altProps', args)
    end

    def get_reservation(args)
      HTTPService.make_request('/ean-services/rs/hotel/v3/res', args, :post, { :reservation_api => true, :use_ssl => true })
    end

    def get_payment_info(args)
      services('/ean-services/rs/hotel/v3/paymentInfo', args)
    end

    def get_cancel(args)
      services('/ean-services/rs/hotel/v3/cancel', args)
    end

    def get_ping(args)
      services('/ean-services/rs/hotel/v3/ping', args)
    end

    def get_static_reservation(args)
      get_reservation(args.merge!({:firstName => "Test Booking", :lastName => "Test Booking", :creditCardType => "CA",
                                   :creditCardNumber => 5401999999999999, :creditCardIdentifier => 123,
                                   :creditCardExpirationMonth => 11, :creditCardExpirationYear => Time.now.year + 2,
                                   :address1 => 'travelnow' }))
    end

    private

      def services(path, args, method=:get)
        HTTPService.make_request(path, args, method)
      end
  end
end
