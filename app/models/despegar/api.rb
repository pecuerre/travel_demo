module Despegar
  class Api

    def test(params)
      response = Despegar::HTTPService.make_request('hotels/availabilities')
      response.body
    end

    def hotels(params)
      if SpreeTravelDemo4::Application.config.mode_offline
        #body = File.open('project/match/acapulco_best_day.txt').readline()
        body = File.open('project/match/cancun_best_day.txt').readline()
        #body = File.open('project/match/ciudad_mexico_best_day.txt').readline()
        body = XmlSimple.xml_in(body)
        hotels = Despegar::Utils.parse_hotels(body, Date.today, Date.today)
        return Despegar::Response.new(hotels)
      end

      if params['search-going-to'].blank? or params['search-check-in-date'].blank? or params['search-check-out-date'].blank?
        return Despegar::Response.new([], ['There is not enough information to verify availability of hotels.'])
      end

      destination = Destination.like_name(params['search-going-to']).first
      return Despegar::Response.new([], ['Destination not found.']) unless destination

      p = Despegar::Utils.prepare_for_hotels(destination.best_day_id, params)
      response = Despegar::HTTPService.make_request('/GetQuoteHotels', p)
      body = XmlSimple.xml_in(response.body)

      if body['Error']
        return Despegar::Response.new([], body['Error'].first['Description'])
      end

      check_in = Date.strptime(params['search-check-in-date'], '%m/%d/%Y')
      check_out = Date.strptime(params['search-check-out-date'], '%m/%d/%Y')
      hotels = Despegar::Utils.parse_hotels(body, check_in, check_out)
      Despegar::Response.new(hotels)
    end

    def cars(params)
      if SpreeTravelDemo4::Application.config.mode_offline
        body = File.open('project/cars_best_day.min.txt').readline()
        body = JSON.parse(body)
        cars = Despegar::Utils.parse_cars(body)
        return Despegar::Response.new(cars)
      end

      if params['search-picking-up'].blank? or params['search-dropping-off'].blank? or
         params['search-pick-up-date'].blank? or params['search-pick-up-time'].blank? or
         params['search-drop-off-date'].blank? or params['search-drop-off-time'].blank?
        return Despegar::Response.new([], ['There is not enough information to verify availability of cars.'])
      end

      destination = Destination.like_name(params['search-picking-up']).first
      return Despegar::Response.new([], ['Destination not found.']) unless destination

      p = Despegar::Utils.prepare_for_cars(destination.best_day_id, params)
      response = Despegar::HTTPService.make_request('/GetQuoteCars', p)
      body = XmlSimple.xml_in(response.body)

      if body['Error']
        return Despegar::Response.new([], body['Error'].first['Description'])
      end

      cars = Despegar::Utils.parse_cars(body)
      Despegar::Response.new(cars)
    end

    def flights(params)
      if SpreeTravelDemo4::Application.config.mode_offline
        body = XmlSimple.xml_in('project/flights_best_day.xml')
        cars = Despegar::Utils.parse_flights(body)
        return Despegar::Response.new(cars)
      end
      
      if params['search-flight-type'].blank? or params['search-flying-from'].blank? or
         params['search-flying-to'].blank? or params['search-departing-date'].blank?
        return Despegar::Response.new([], ['There is not enough information to verify availability of flights.'])
      end

      departure_airport = Airport.like_location_and_iata(params['search-flying-from']).first
      return Despegar::Response.new([], ["Airport name or destination not found for #{params['search-flying-from']}."]) unless departure_airport

      arrival_airport = Airport.like_location_and_iata(params['search-flying-to']).first
      return Despegar::Response.new([], ["Airport name or destination not found for #{params['search-flying-to']}."]) unless arrival_airport

      p = Despegar::Utils.prepare_for_flights(departure_airport, arrival_airport, params)
      response = Despegar::HTTPService.make_request('/GetQuoteFlights', p)
      body = XmlSimple.xml_in(response.body)

      if body['Error']
        return Despegar::Response.new([], body['Error'].first['Description'])
      end

      flights = Despegar::Utils.parse_flights(body)
      Despegar::Response.new(flights)
    end

    def packages(params)
      if SpreeTravelDemo4::Application.config.mode_offline
        body = File.open('project/packages_best_day.txt').readline()
        body = JSON.parse(body)
        packages = Despegar::Utils.parse_packages(body, Date.today, Date.today)
        return Despegar::Response.new(packages)
      end

      if params['search-going-to'].blank? or params['search-flying-from'].blank? or
         params['search-arrival-date'].blank? or params['search-departure-date'].blank? or
         params['search-rooms'].blank? or params['search-adults'].blank? or params['search-kids'].blank?
        return Despegar::Response.new([], ['There is not enough information to verify availability of packages.'])
      end

      destination = Destination.like_name(params['search-going-to']).first
      return Despegar::Response.new([], ['Destination not found.']) unless destination

      departure_airport = Airport.like_location_and_iata(params['search-flying-from']).first
      return Despegar::Response.new([], ['Airport name or destination not found.']) unless departure_airport

      arrival_airport = Airport.like_location_and_iata(params['search-going-to']).first
      return Despegar::Response.new([], ['Airport name or destination not found.']) unless arrival_airport

      p = Despegar::Utils.prepare_for_packages(destination.best_day_id, departure_airport.iata, arrival_airport.iata, params)
      response = Despegar::HTTPService.make_request('/GetQuotePackages', p)
      body = XmlSimple.xml_in(response.body)

      if body['Error']
        return Despegar::Response.new([], body['Error'].first['Description'])
      end

      arrival_date = Date.strptime(params['search-arrival-date'], '%m/%d/%Y')
      departure_date = Date.strptime(params['search-departure-date'], '%m/%d/%Y')
      packages = Despegar::Utils.parse_packages(body, arrival_date, departure_date)
      Despegar::Response.new(packages)
    end

  end
end