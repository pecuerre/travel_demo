module Despegar
  class Utils
    @@currencies = {
        'USD' => 'US'
    }

    @@languages = {
        'en-US' => 'ING'
    }

    def self.prepare_for_hotels(destination_id, params)
      p = {}
      p['a'] = 'MOREMEX'
      p['ip'] = '200.55.139.220'
      p['c'] = @@currencies[Spree::Config.currency]
      p['sd'] = Date.strptime(params['search-check-in-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['ed'] = Date.strptime(params['search-check-out-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['h'] = ''
      p['rt'] = ''
      p['mp'] = ''
      rooms = params['search-rooms'].to_i
      adults = params['search-adults'].to_i
      kids = params['search-kids'].to_i
      dist = Master::Utils.distribute_adults_and_kids(rooms, adults, kids)
      p['r'] = rooms
      (1..[rooms, 5].min).each do |r|
        p["r#{r}a"] = dist[:adults][r-1]
        p["r#{r}k"] = kids = [dist[:kids][r-1].count, 3].min
        (1..3).each do |k|
          p["r#{r}k#{k}a"] = k <= kids ? dist[:kids][r-1][k-1] : 0
        end
      end
      p['d'] = destination_id
      p['l'] = @@languages[Spree::Config.preferred_language]
      p['hash'] = ''
      p
    end

    def self.parse_hotels(resources, check_in, check_out)
      hotels = []
      resources['Hotels'].first['Hotel'].each do |resource|
        hotel = Hotel.new
        hotel.id = resource['Id'].first.to_i
        hotel.name = resource['Name'].first
        hotel.name_slug = normalize(hotel.name)
        hotel.description = resource['Description'].first
        hotel.address = resource['Street'].first
        hotel.address_slug = normalize(hotel.address)
        hotel.city = resource['CityName'].first
        #hotel.state =
        hotel.country = resource['CountryName'].first
        hotel.booking_uri = {:best_day => "http://www.e-travelsolution.com.mx/Partners/Reservations/Hotels/info.aspx?asoc=test&ID=#{hotel.id}&anio_desde=#{check_in.year}&mes_desde=#{check_in.month}&dia_Desde=#{check_in.day}&anio_hasta=#{check_out.year}&mes_hasta=#{check_out.month}&dia_hasta=#{check_out.day}"}
        hotel.image_uri = resource['Image'].first.sub('//','http://')
        meal_plans = resource['Rooms'].first['Room'].collect{|r| r['MealPlans'].first['MealPlan'].first if r['MealPlans'].first['MealPlan']}.select{|m| not m.blank?}
        rate = meal_plans.collect{|m| m['AverageGrossTotal'].first.to_f.round(2)}
        hotel.low_rate = {:best_day => rate.min}
        hotel.high_rate = {:best_day => rate.max}
        #hotel.chain =
        if resource['Reviews'] and resource['Reviews'].first['Review']
          hotel.rating = resource['Reviews'].first['Review'].find{|r| r['Source'].first == 'TripAdvisor'}['Rating'].first.to_f
        else
          hotel.rating = 4.0
        end
        hotel.latitude = resource['Latitude'].first
        hotel.longitude = resource['Longitude'].first
        if resource['Reviews'] and resource['Reviews'].first['Review']
          hotel.reviews = resource['Reviews'].first['Review'].first['Count'].first.to_i
        end
        hotel.prices = hotel.low_rate
        hotel.api = :best_day
        hotels << hotel
      end
      hotels
    end

    def self.prepare_for_cars(destination_id, params)
      p = {}
      p['a'] = 'MOREMEX'
      p['c'] = @@currencies[Spree::Config.currency]
      p['sd'] = Date.strptime(params['search-pick-up-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['ed'] = Date.strptime(params['search-drop-off-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['d'] = destination_id
      p['l'] = 'esp' #@@languages[Spree::Config.preferred_language]
      p['sh'] = Time.strptime(params['search-pick-up-time'], '%l:%M %P').strftime('%H%M')
      p['eh'] = Time.strptime(params['search-drop-off-time'], '%l:%M %P').strftime('%H%M')
      p['xi'] = ''
      p['xai'] = ''
      p['ip'] = '200.55.139.220'
      p
    end

    def self.parse_cars(resources)
      cars = []
      resources['Cars'].first['Car'].each do |resource|
        car = Car.new
        car.id = resource['Id'].first
        car.name = resource['Name'].first
        car.description = resource['Description'].first
        car.air_conditioning = resource['AirConditioning'].first == 'true'
        car.passengers = resource['Passengers'].first.to_i
        car.suitcases = resource['Suitcases'].first.to_i
        car.transmission = resource['Transmission'].first
        car.image = resource['Image'].first['URL'].first.sub('//','http://')
        car.type = resource['Type'].first['Name'].first
        car.agency = resource['BranchName'].first
        car.api = :best_day
        car.prices = {:best_day => resource['Rate'].first['Total'].first.to_f.round(2)}
        car.booking_uri = {:best_day => ''}
        cars << car
      end
      cars
    end

    def self.prepare_for_packages(destination_id, departure_airport_iata, arrival_airport_iata, params)
      p = {}
      p['a'] = 'MOREMEX'
      p['ip'] = '200.55.139.220'
      p['c'] = @@currencies[Spree::Config.currency]
      p['sd'] = Date.strptime(params['search-arrival-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['ed'] = Date.strptime(params['search-departure-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['h'] = ''
      rooms = params['search-rooms'].to_i
      adults = params['search-adults'].to_i
      kids = params['search-kids'].to_i
      dist = Master::Utils.distribute_adults_and_kids(rooms, adults, kids)
      p['r'] = rooms
      (1..[rooms, 5].min).each do |r|
        p["r#{r}a"] = dist[:adults][r-1]
        p["r#{r}k"] = kids = [dist[:kids][r-1].count, 3].min
        (1..3).each do |k|
          p["r#{r}k#{k}a"] = k <= kids ? dist[:kids][r-1][k-1] : 0
        end
      end
      p['d'] = destination_id
      p['dd'] = departure_airport_iata
      p['da'] = arrival_airport_iata
      p['l'] = @@languages[Spree::Config.preferred_language]
      p['cb'] = ''
      p['hash'] = ''
      p
    end

    def self.parse_packages(resources, arrival_date, departure_date)
      packages = []
      hotels = self.parse_hotels(resources, arrival_date, departure_date)
      flights = self.parse_flights(resources)
      hotels.each do |hotel|
        package = Package.new
        package.hotel = hotel
        package.flight = flights.first
        package.prices = package.hotel.prices.merge(package.flight.prices){|k, h, f| (h+f).round(2)}
        package.api = :best_day
        package.booking_uri = {:best_day => ''}
        packages << package
      end
      packages
    end

    def self.prepare_for_flights(departure_airport, arrival_airport, params)
      p = {}
      p['a'] = 'MOREMEX'
      p['c'] = @@currencies[Spree::Config.currency]
      p['sd'] = Date.strptime(params['search-departing-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['ed'] = Date.strptime(params['search-returning-date'], '%m/%d/%Y').strftime('%Y%m%d') rescue p['sd']
      p['at'] = params['search-adults']
      p['ki'] = params['search-kids']
      p['dd'] = departure_airport.iata
      p['da'] = arrival_airport.iata
      p['l'] = @@languages[Spree::Config.preferred_language]
      p['tv'] = params['search-flight-type'] == 'Roundtrip' ? 'R' : 'O'
      p['ty'] = 'fl'
      p['hash'] = ''
      p['ip'] = '200.55.139.220'
      p
    end

    def self.parse_flights(resources)
      flights = []
      resources['Flights'].first['Flight'].each do |resource|
        flight = Flight.new
        flight.id = resource['Id'].first
        flight.image_uri = resource['Streches'].first['Strech'].first['Image'].first['URL'].first.sub('//','http://')
        flight.airline = resource['Streches'].first['Strech'].first['AirlineName'].first

        departures = []
        resource['Streches'].first['Strech'].each do |strech|
          departure = Departure.new
          departure.airline = strech['AirlineName'].first
          departure.duration_in_minutes = strech['Segments'].first['Segment'].first['Duration'].first
          
          date_time = "#{strech['Departure'].first['Date'].first} #{strech['Departure'].first['Time'].first}"
          departure.departure_date_time = DateTime.strptime(date_time, '%Y-%m-%d %H:%M')
          departure.departure_airport_code = strech['Departure'].first['Airport'].first

          date_time = "#{strech['Arrival'].first['Date'].first} #{strech['Arrival'].first['Time'].first}"
          departure.arrival_date_time = DateTime.strptime(date_time, '%Y-%m-%d %H:%M')
          departure.arrival_airport_code = strech['Arrival'].first['Airport'].first

          departure.flight_number = strech['Segments'].first['Segment'].first['FlightNumber'].first
          departure.booking_class = strech['Segments'].first['Segment'].first['Class'].first

          departures << departure
        end

        flight.departure_flights = [departures[0]]
        flight.returning_flights = departures.count > 1 ? [departures[1]] : []

        flight.prices = {:best_day => resource['TotalRate'].first.to_f.round(2)}
        flight.api = :best_day

        flights << flight
      end
      flights
    end

    def self.normalize(phrase)
      Master::Match.normalize(phrase)
    end
  end
end