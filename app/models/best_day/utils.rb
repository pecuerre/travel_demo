module BestDay
  class Utils
    CURRENCIES = {
        'USD' => 'US'
    }

    LANGUAGES = {
        :en => 'ING',
        :es => 'ESP'
    }

    def self.prepare_for_hotels(destination_id, params)
      p = {}
      p['a'] = 'MOREMEX'
      p['ip'] = '200.55.139.220'
      p['c'] = CURRENCIES[Spree::Config.currency]
      p['sd'] = Date.strptime(params['search-check-in-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['ed'] = Date.strptime(params['search-check-out-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['h'] = ''
      p['rt'] = ''
      p['mp'] = ''
      rooms = params['search-rooms'].to_i
      adults = params['search-adults'].to_i
      kids = params['search-kids'].blank? ? 0 : params['search-kids'].to_i
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
      p['l'] = LANGUAGES[(params['locale'] || I18n.locale).to_sym]
      p['hash'] = ''
      p
    end

    def self.parse_hotels(resources, params=nil, data=nil)
      hotels = []
      resources['Hotels'].first['Hotel'].each do |resource|
        hotel = Hotel.new
        hotel.id = resource['Id'].first.to_i
        hotel.name = resource['Name'].first
        hotel.name_slug = normalize(hotel.name)
        hotel.description = resource['Description'].first
        hotel.address = resource['Street'].first.to_s
        hotel.address_slug = normalize(hotel.address)
        hotel.city = resource['CityName'].first
        #hotel.state =
        hotel.country = resource['CountryName'].first
        hotel.image_uri = resource['Image'].first.sub('//','http://')
        hotel.room_type = resource['Rooms'].first['Room'].first['Name'].first

        meal_plan = resource['Rooms'].first['Room'].first['MealPlans'].first rescue {}
        if !meal_plan.empty?
          hotel.meal_plan = meal_plan['MealPlan'][0]['Name'].first
          hotel.prices = {:best_day => meal_plan['MealPlan'][0]['Total'].first.to_f.round }
        end

        if resource['Reviews'] && resource['Reviews'].first['Review']
          hotel.rating = resource['Reviews'].first['Review'].find{|r| r['Source'].first == 'TripAdvisor'}['Rating'].first.to_f
          hotel.reviews = resource['Reviews'].first['Review'].first['Count'].first.to_i
        else
          hotel.rating = 4.0
          hotel.reviews = 'No'
        end
        hotel.latitude = resource['Latitude'].first
        hotel.longitude = resource['Longitude'].first
        hotel.api = {name: :best_day, string: 'BestDay'}

        if params && data

          sd = Date.strptime(params['search-check-in-date'], '%m/%d/%Y').strftime('%Y/%m/%d')
          ed = Date.strptime(params['search-check-out-date'], '%m/%d/%Y').strftime('%Y/%m/%d')
          query = "af=MOREMEX&ln=#{LANGUAGES[(params['locale'] || I18n.locale).to_sym]}&cu=#{CURRENCIES[Spree::Config.currency]}&sd=#{sd}&ed=#{ed}&ht=#{hotel.id}&hn=#{hotel.name}&ds=#{data['d']}&dn=#{params['search-going-to']}"
          rooms = params['search-rooms'].to_i
          adults = params['search-adults'].to_i
          kids = params['search-kids'].blank? ? 0 : params['search-kids'].to_i
          dist = Master::Utils.distribute_adults_and_kids(rooms, adults, kids)
          query += "&rm=#{rooms}"
          rooms.times do |r|
            query += "&ad#{r+1}=#{dist[:adults][r]}"
            query += "&ch#{r+1}=#{dist[:kids][r].count}"
            query += "&ac#{r+1}=#{dist[:kids][r].join(',')}"
          end
          hotel.same_booking_uri = {:best_day => "http://www.e-tsw.com/Hotels/Rates?#{query}"}
          hotel.booking_uri = {:best_day => "http://www.e-tsw.com/Hotels/Rates?#{query}"}

        end

        if hotel.prices
          hotels << hotel
        end

      end
      hotels
    end

    # def self.prepare_for_cars(pick, drop, params)
    #   p = {}
    #   p['a'] = 'MOREMEX'
    #   p['c'] = CURRENCIES[Spree::Config.currency]
    #   p['sd'] = Date.strptime(params['search-pick-up-date'], '%m/%d/%Y').strftime('%Y%m%d')
    #   p['ed'] = Date.strptime(params['search-drop-off-date'], '%m/%d/%Y').strftime('%Y%m%d')
    #   p['l'] = LANGUAGES[(params['locale'] || I18n.locale).to_sym]
    #   p['sh'] = Time.strptime(params['search-pick-up-time'], '%l:%M %P').strftime('%H%M')
    #   p['eh'] = Time.strptime(params['search-drop-off-time'], '%l:%M %P').strftime('%H%M')
    #   p['xi'] = ''
    #   p['p'] = pick  #Ciudad de entrega del carro
    #   p['pxai'] = ''
    #   p['d'] = drop  #Ciudad de Devolición del carro
    #   p['dxai'] = ''
    #   p['ip'] = '200.55.139.220'
    #   p
    # end

    def self.prepare_for_cars(destination_id, params)
      p = {}
      p['a'] = 'MOREMEX'
      p['c'] = CURRENCIES[Spree::Config.currency]
      p['sd'] = Date.strptime(params['search-pick-up-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['ed'] = Date.strptime(params['search-drop-off-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['d'] = destination_id
      p['l'] = LANGUAGES[(params['locale'] || I18n.locale).to_sym]
      p['sh'] = Time.strptime(params['search-pick-up-time'], '%l:%M %P').strftime('%H%M')
      p['eh'] = Time.strptime(params['search-drop-off-time'], '%l:%M %P').strftime('%H%M')
      p['xi'] = ''
      p['xai'] = ''
      p['ip'] = '200.55.139.220'
      p
    end

    def self.parse_cars(resources, params=nil, data=nil)
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
        car.api = { name: :best_day, string: 'BestDay'}
        car.prices = {:best_day => resource['Rate'].first['Total'].first.to_f.round}

        if !params.nil? && !data.nil?
          sd = Date.strptime(params['search-pick-up-date'], '%m/%d/%Y').strftime('%Y/%m/%d')
          ed = Date.strptime(params['search-drop-off-date'], '%m/%d/%Y').strftime('%Y/%m/%d')
          query = "af=MOREMEX&ln=#{LANGUAGES[(params['locale'] || I18n.locale).to_sym]}&cu=#{CURRENCIES[Spree::Config.currency]}&sd=#{sd}&ed=#{ed}&ht=#{car.id}&hn=#{car.name}&ds=#{data['d']}&dn=#{params['search-going-to']}"
          rooms = params['search-rooms'].to_i
          adults = params['search-adults'].to_i
          kids = params['search-kids'].blank? ? 0 : params['search-kids'].to_i
          dist = Master::Utils.distribute_adults_and_kids(rooms, adults, kids)
          query += "&rm=#{rooms}"
          rooms.times do |r|
            query += "&ad#{r+1}=#{dist[:adults][r]}"
            query += "&ch#{r+1}=#{dist[:kids][r].count}"
            query += "&ac#{r+1}=#{dist[:kids][r].join(',')}"
          end
          car.same_booking_uri = {:best_day => "http://www.e-tsw.com/Cars/Rates?#{query}"}
          car.booking_uri = {:best_day => "http://www.e-tsw.com/Cars/Rates?#{query}"}
        end

        # car.same_booking_uri = {:best_day => ''}
        # car.booking_uri = {:best_day => ''}

        cars << car
      end
      cars
    end

    def self.prepare_for_packages(destination_id, departure_airport_iata, arrival_airport_iata, params)
      p = {}
      p['a'] = 'MOREMEX'
      p['ip'] = '200.55.139.220'
      p['c'] = CURRENCIES[Spree::Config.currency]
      p['sd'] = Date.strptime(params['search-arrival-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['ed'] = Date.strptime(params['search-departure-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['h'] = ''
      rooms = params['search-rooms'].to_i
      adults = params['search-adults'].to_i
      kids = params['search-kids'].blank? ? 0 : params['search-kids'].to_i
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
      p['l'] = LANGUAGES[(params['locale'] || I18n.locale).to_sym]
      p['cb'] = ''
      p['hash'] = ''
      p
    end

    def self.parse_packages(resources, params=nil, data=nil)
      packages = []
      params['search-departing-date'] = params['search-check-in-date'] = params['search-arrival-date']
      params['search-returning-date'] = params['search-check-out-date'] = params['search-departure-date']
      hotels = self.parse_hotels(resources, params, data)
      flights = self.parse_flights(resources, params, data)
      hotels.each do |hotel|
        package = Package.new
        package.hotel = hotel
        package.flight = flights.first
        package.prices = package.hotel.prices
        package.api = {name: :best_day, string: 'BestDay'}

        ht = hotel.id
        sd = Date.strptime(params['search-arrival-date'], '%m/%d/%Y').strftime('%Y-%m-%d')
        ed = Date.strptime(params['search-departure-date'], '%m/%d/%Y').strftime('%Y-%m-%d')
        rooms = params['search-rooms'].to_i
        adults = params['search-adults'].to_i
        kids = params['search-kids'].blank? ? 0 : params['search-kids'].to_i
        dist = Master::Utils.distribute_adults_and_kids(rooms, adults, kids)
        package.same_booking_uri = {:best_day => "http://www.e-tsw.com/Paquetes/Resultados?af=MoreMex&ln=#{data['l'].downcase}&cu=#{data['c']}&ob=#{data['dd']}&ib=#{data['da']}&ds=#{data['d']}&sd=#{sd}&ed=#{ed}&rm=#{rooms}&ht=#{ht}"}
        package.booking_uri = {:best_day => "http://www.e-tsw.com/Paquetes/Resultados?af=MoreMex&ln=#{data['l'].downcase}&cu=#{data['c']}&ob=#{data['dd']}&ib=#{data['da']}&ds=#{data['d']}&sd=#{sd}&ed=#{ed}&rm=#{rooms}&ht=#{ht}"}
        (1..rooms).each do |r|
          package.booking_uri[:best_day] += "&ad#{r}=#{dist[:adults][r-1]}"
          package.booking_uri[:best_day] += "&ch#{r}=#{dist[:kids][r-1].count}"
        end

        packages << package
      end
      packages
    end

    def self.prepare_for_flights(departure_airport, arrival_airport, params)
      p = {}
      p['a'] = 'MOREMEX'
      p['c'] = CURRENCIES[Spree::Config.currency]
      p['sd'] = Date.strptime(params['search-departing-date'], '%m/%d/%Y').strftime('%Y%m%d')
      p['ed'] = Date.strptime(params['search-returning-date'], '%m/%d/%Y').strftime('%Y%m%d') rescue p['sd']
      p['at'] = params['search-adults']
      p['ki'] = params['search-kids'].blank? ? 0 : params['search-kids'].to_i
      p['d'] = ''
      p['dd'] = departure_airport.iata
      p['da'] = arrival_airport.iata
      p['l'] = LANGUAGES[(params['locale'] || I18n.locale).to_sym]
      p['cb'] = ''
      p['tv'] = params['search-flight-type'] == 'roundtrip' ? 'R' : 'O'
      p['ty'] = 'FL'
      p['hash'] = ''
      p['ip'] = '200.55.139.220'
      p
    end

    def self.parse_flights(resources, params=nil, data=nil)
      flights = []
      resources['Flights'].first['Flight'].each do |resource|
        flight = Flight.new
        flight.id = resource['Id'].first
        flight.image_uri = resource['Streches'].first['Strech'].first['Image'].first['URL'].first.sub('//','http://')
        flight.airline = resource['Streches'].first['Strech'].first['AirlineName'].first

        resource['Streches'].first['Strech'].each do |strech|
          departures = []
          strech['Segments'].first['Segment'].each do |segment|
            departure = Departure.new
            departure.airline = strech['AirlineName'].first
            departure.duration_in_minutes = segment['Duration'].first

            date_time = "#{segment['Departure'].first['Date'].first} #{segment['Departure'].first['Time'].first}"
            departure.departure_date_time = DateTime.strptime(date_time, '%Y-%m-%d %H:%M')
            departure.departure_airport_code = segment['Departure'].first['Airport'].first

            date_time = "#{segment['Arrival'].first['Date'].first} #{segment['Arrival'].first['Time'].first}"
            departure.arrival_date_time = DateTime.strptime(date_time, '%Y-%m-%d %H:%M')
            departure.arrival_airport_code = segment['Arrival'].first['Airport'].first

            departure.flight_number = segment['FlightNumber'].first
            departure.booking_class = segment['Class'].first

            departures << departure
          end

          if strech == resource['Streches'].first['Strech'].first && resource['Streches'].first['Strech'].count == 1
            flight.departure_flights = departures
            flight.returning_flights = []
          else
            if strech == resource['Streches'].first['Strech'].first
              flight.departure_flights = departures
            else
              flight.returning_flights = departures
            end
          end
        end

        flight.prices = {:best_day => resource['TotalRate'].first.to_f.round}
        # flight.prices = {:best_day => resource['PaxRate'].first.to_f}
        flight.api = { name: :best_day, string: 'BestDay'}

        if params && data
          if data['tv'] == 'R'
            ti = 'round'
          else
            ti = 'one'
          end
          sd = Date.strptime(params['search-departing-date'], '%m/%d/%Y').strftime('%Y-%m-%d')
          if data['tv'] == 'R'
            ed = Date.strptime(params['search-returning-date'], '%m/%d/%Y').strftime('%Y-%m-%d')
          else
            ed=''
          end
          flight.booking_uri = {:best_day => "http://www.e-tsw.com/Vuelos/Lista?af=MoreMex&ln=#{data['l'].downcase}&cu=#{data['c']}&ob=#{data['dd']}&ib=#{data['da']}&sd=#{sd}&ed=#{ed}&ad1=#{params['search-adults']}&ch1=#{params['search-kids']}&ti=#{ti}"}
          flight.same_booking_uri = {:best_day => "http://www.e-tsw.com/Vuelos/Lista?af=MoreMex&ln=#{data['l'].downcase}&cu=#{data['c']}&ob=#{data['dd']}&ib=#{data['da']}&sd=#{sd}&ed=#{ed}&ad1=#{params['search-adults']}&ch1=#{params['search-kids']}&ti=#{ti}"}
        end

        flights << flight
      end
      flights
    end

    def self.normalize(phrase)
      Master::Match.normalize(phrase)
    end
  end
end
