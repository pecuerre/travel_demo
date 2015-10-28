require 'xmlsimple'

module BestDay
  class Api

    def hotels(params)

      if SpreeTravelDemo4::Application.config.mode_offline
        body = File.open('project/best_day/hotels2.txt').readline()
        body = XmlSimple.xml_in(body)
        hotels = BestDay::Utils.parse_hotels(body) #, params, data)
        # hotels = Kaminari.paginate_array(hotels).page(params[:page])
        return BestDay::Response.new(hotels)
      else

        if not params['search-going-to'] or params['search-going-to'] == '' or not params['search-check-in-date'] or params['search-check-in-date'] == '' or not params['search-check-out-date'] or params['search-check-out-date'] == ''
          return BestDay::Response.new([], ['There is not enough information to verify availability of hotels.'])
        end

        destination = Destination.like_name(params['search-going-to']).first
        return BestDay::Response.new([], ['Destination not found.']) unless destination

        data = BestDay::Utils.prepare_for_hotels(destination.best_day_id, params)

        begin
          response = BestDay::HTTPService.make_request('/GetQuoteHotels', data)
        rescue StandardError => e
          return BestDay::Response.new([], [e.to_s])
        else
          body = XmlSimple.xml_in(response.body)
          hotels = BestDay::Utils.parse_hotels(body, params, data)
        end

        if body['Error']
          return BestDay::Response.new([], body['Error'].first['Description'])
        end

        BestDay::Response.new(hotels)

      end
    end

    def cars(params)
      if SpreeTravelDemo4::Application.config.mode_offline
        body = File.open('project/cars_best_day.min.txt').readline()
        body = JSON.parse(body)
        cars = BestDay::Utils.parse_cars(body)
        # cars = Kaminari.paginate_array(cars).page(params[:page])
        return BestDay::Response.new(cars)

      else

        if params['search-picking-up'].blank? or params['search-dropping-off'].blank? or
           params['search-pick-up-date'].blank? or params['search-pick-up-time'].blank? or
           params['search-drop-off-date'].blank? or params['search-drop-off-time'].blank?
          return BestDay::Response.new([], ['There is not enough information to verify availability of cars.'])
        end


        # # PIKING UP
        # pick_destination = Destination.like_name(params['search-picking-up']).first
        # return BestDay::Response.new([], ['Destination not found.']) unless pick_destination
        #
        # for_ota = [['a', 'MOREMEX'],["d", pick_destination.best_day_id],['l', 'ING']]
        #
        # pick = ''
        # begin
        #   response = BestDay::HTTPService.cities('/GetCities', for_ota )
        # rescue StandardError => e
        #   return BestDay::Response.new([], [e.to_s])
        # else
        #   body = XmlSimple.xml_in(response.body)
        #   body['City'].each do |b|
        #     if b['Name'].first == params['search-picking-up']
        #       pick = b['Id'].first
        #     end
        #   end
        # end
        #
        # # DROPING OFF
        # drop_destination = Destination.like_name(params['search-dropping-off']).first
        # return BestDay::Response.new([], ['Destination not found.']) unless drop_destination
        #
        # for_ota = [['a', 'MOREMEX'],["d", drop_destination.best_day_id],['l', 'ING']]
        #
        # drop = ''
        # begin
        #   response = BestDay::HTTPService.cities('/GetCities', for_ota )
        # rescue StandardError => e
        #   return BestDay::Response.new([], [e.to_s])
        # else
        #   body = XmlSimple.xml_in(response.body)
        #   body['City'].each do |b|
        #     if b['Name'].first == params['search-dropping-off']
        #       drop = b['Id'].first
        #     end
        #   end
        # end
        #
        # p = BestDay::Utils.prepare_for_cars(pick, drop, params)
        #
        # begin
        #   response = BestDay::HTTPService.make_request('/GetQuoteCars', p)
        # rescue StandardError => e
        #   return BestDay::Response.new([], [e.to_s])
        # else
        #   body = XmlSimple.xml_in(response.body)
        # end
        #
        # if body['Error']
        #   return BestDay::Response.new([], body['Error'].first['Description'])
        # end
        #
        # cars = BestDay::Utils.parse_cars(body, params, p)
        # # cars = Kaminari.paginate_array(cars).page(params[:page])
        # BestDay::Response.new(cars)

        if params['search-picking-up'].blank? or params['search-dropping-off'].blank? or
            params['search-pick-up-date'].blank? or params['search-pick-up-time'].blank? or
            params['search-drop-off-date'].blank? or params['search-drop-off-time'].blank?
          return BestDay::Response.new([], ['There is not enough information to verify availability of cars.'])
        end

        destination = Destination.like_name(params['search-picking-up']).first
        return BestDay::Response.new([], ['Destination not found.']) unless destination

        p = BestDay::Utils.prepare_for_cars(destination.best_day_id, params)

        begin
          response = BestDay::HTTPService.make_request('/GetQuoteCars', p)
        rescue StandardError => e
          return BestDay::Response.new([], [e.to_s])
        else
          body = XmlSimple.xml_in(response.body)
        end

        if body['Error']
          return BestDay::Response.new([], body['Error'].first['Description'])
        end

        cars = BestDay::Utils.parse_cars(body, params, p)
        cars = Kaminari.paginate_array(cars).page(params[:page])
        BestDay::Response.new(cars)


      end
    end

    def flights(params)

        departure_airport = Airport.like_location_and_iata(params['search-flying-from']).first
        return BestDay::Response.new([], ["Airport name or destination not found for #{params['search-flying-from']}."]) unless departure_airport

        arrival_airport = Airport.like_location_and_iata(params['search-flying-to']).first
        return BestDay::Response.new([], ["Airport name or destination not found for #{params['search-flying-to']}."]) unless arrival_airport

        data = BestDay::Utils.prepare_for_flights(departure_airport, arrival_airport, params)

      if SpreeTravelDemo4::Application.config.mode_offline
        body = XmlSimple.xml_in('project/best_day/BestDay')
        flights = BestDay::Utils.parse_flights(body, params, data)
        # flights = Kaminari.paginate_array(flights).page(params[:page])
        return BestDay::Response.new(flights)
      else

          if params['search-flight-type'].blank? or params['search-flying-from'].blank? or
             params['search-flying-to'].blank? or params['search-departing-date'].blank?
            return BestDay::Response.new([], ['There is not enough information to verify availability of flights.'])
          end

          begin
            response = BestDay::HTTPService.make_request('/GetQuoteFlights', data)
          rescue StandardError => e
            return BestDay::Response.new([], [e.to_s])
          else
            body = XmlSimple.xml_in(response.body)
          end

          if body['Error']
            return BestDay::Response.new([], body['Error'].first['Description'])
          end

          flights = BestDay::Utils.parse_flights(body, params, data)
          # flights = Kaminari.paginate_array(flights).page(params[:page])
          BestDay::Response.new(flights)
      end
    end

    def packages(params)

      if SpreeTravelDemo4::Application.config.mode_offline
        body = File.open('project/packages_best_day.txt').readline()
        params = {"search-type"=>"packages", "locale"=>"en", "http-referer"=>"products_path", "search-going-to"=>"cancun", "search-flying-from"=>"Miami, Florida, United States (MIA)", "search-arrival-date"=>"05/23/2015", "search-departure-date"=>"05/30/2015", "search-rooms"=>"1", "search-adults"=>"2", "search-kids"=>""}
        body = JSON.parse(body)
        data = BestDay::Utils.prepare_for_packages(2, 'MIA', 'MEX', params)
        packages = BestDay::Utils.parse_packages(body, params, data)
        return BestDay::Response.new(packages)
      else

        destination = Destination.like_name(params['search-going-to']).first
        return BestDay::Response.new([], ['Destination not found.']) unless destination

        departure_airport = Airport.like_location_and_iata(params['search-flying-from']).first
        return BestDay::Response.new([], ['Airport name or destination not found.']) unless departure_airport

        arrival_airport = Airport.like_location_slug(params['search-going-to']).first
        return BestDay::Response.new([], ['Airport name or destination not found.']) unless arrival_airport

        data = BestDay::Utils.prepare_for_packages(destination.best_day_id, departure_airport.iata, arrival_airport.iata, params)


        if params['search-going-to'].blank? or params['search-flying-from'].blank? or
           params['search-arrival-date'].blank? or params['search-departure-date'].blank? or
           params['search-rooms'].blank? or params['search-adults'].blank?
          return BestDay::Response.new([], ['There is not enough information to verify availability of packages.'])
        end

        begin
          response = BestDay::HTTPService.make_request('/GetQuotePackages', data)
        rescue StandardError => e
          return BestDay::Response.new([], [e.to_s])
        else
          body = XmlSimple.xml_in(response.body)
        end

        if body['Error']
          return BestDay::Response.new([], body['Error'].first['Description'])
        end

        packages = BestDay::Utils.parse_packages(body, params, data)
        BestDay::Response.new(packages)

      end

    end

  end
end
