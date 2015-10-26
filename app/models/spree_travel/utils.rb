module SpreeTravel
  class Utils

    LANGUAGES = {
        :en => 'en-US',
        :es => 'es-MX'
    }

    def self.availability_params_present?(params)
      return false if params['search-going-to'].empty?
      return false if params['search-check-in-date'].empty?
      return false if params['search-check-out-date'].empty?
      true
    end

    def self.normalize(phrase)
      Master::Match.normalize(phrase)
    end

    def self.hotel_booking_uri(product, params)

    end

    def self.parse_hotels(products, params)
      hotels = []
      products.each do |product|
        product = Spree::Produc.new
        hotel = Hotel.new
        hotel.id = product.id
        hotel.name = product.name
        hotel.name_slug = normalize(hotel.name)
        hotel.description = product.description
        # hotel.address = product.address
        # hotel.address_slug = normalize(hotel.address)
        # hotel.city = product.city
        # hotel.state = product.state
        # hotel.country = product.country
        hotel.image_uri = product.images.first.attachment.url
        # hotel.low_rate = {}
        # hotel.high_rate = {}
        # hotel.chain = product.chain
        # hotel.rating = product.rating
        hotel.reviews = 'No'
        # hotel.latitude =
        # hotel.longitude =
        product['RatePlans'].sort_by! {|h| h['TotalAmount']}
        hotel.prices = {:spree_travel => product.price }
        hotel.api = {name: :spree_travel, string: 'SpreeTravel'}
        hotel.room_type = product.variant.name
        hotel.booking_uri = hotel_booking_uri(product, params)
        # hotel.same_booking_uri = hotel.booking_uri
        hotels << hotel
      end
      hotels
    end

    def self.parse_flights(resources, params=nil, data=nil)
      flights = []
      resources.each do |resource|
        flight = Flight.new
        flight.airline = resource['Airline']
        flight.duration_in_minutes = resource['DurationHours'].to_i * 60 + resource['DurationMinutes']
        flight.prices = {:price_travel => resource['TotalPrice'].to_f.round}
        flight.api = {name: :price_travel, string: 'PriceTravel'}
        flight.image_uri = flight.image


        flight.departure_flights = []
        resource['DepartureFlights'].each do |resource_departure_flight|
          departure = Departure.new
          departure.airline = resource_departure_flight['Airline']
          departure.duration_in_minutes = resource_departure_flight['DurationHours'].to_i * 60 + resource_departure_flight['DurationMinutes']
          departure.departure_date_time = DateTime.strptime(resource_departure_flight['DepartureDateTime']) rescue DateTime.strptime(resource_departure_flight['DepartureDateTime'],'%Y-%m-%dT%H:%M:%S')
          departure.arrival_date_time = DateTime.strptime(resource_departure_flight['ArrivalDateTime']) rescue DateTime.strptime(resource_departure_flight['ArrivalDateTime'],'%Y-%m-%dT%H:%M:%S')
          departure.terminal = resource_departure_flight['Terminal']
          departure.departure_airport = resource_departure_flight['DepartureAirport']
          departure.departure_airport_code = resource_departure_flight['DepartureAirportCode']
          departure.arrival_airport = resource_departure_flight['ArrivalAirport']
          departure.arrival_airport_code = resource_departure_flight['ArrivalAirportCode']
          departure.flight_number = resource_departure_flight['FlightNumber']
          departure.booking_class = resource_departure_flight['BookingClass']
          flight.departure_flights << departure
        end

        flight.returning_flights = []
        resource['ReturningFlights'].each do |resource_returning_flight|
          departure = Departure.new
          departure.airline = resource_returning_flight['Airline']
          departure.duration_in_minutes = resource_returning_flight['DurationHours'].to_i * 60 + resource_returning_flight['DurationMinutes']
          departure.departure_date_time = DateTime.strptime(resource_returning_flight['DepartureDateTime']) rescue DateTime.strptime(resource_returning_flight['DepartureDateTime'],'%Y-%m-%dT%H:%M:%S')
          departure.arrival_date_time = DateTime.strptime(resource_returning_flight['ArrivalDateTime']) rescue DateTime.strptime(resource_returning_flight['ArrivalDateTime'],'%Y-%m-%dT%H:%M:%S')
          departure.terminal = resource_returning_flight['Terminal']
          departure.departure_airport = resource_returning_flight['DepartureAirport']
          departure.departure_airport_code = resource_returning_flight['DepartureAirportCode']
          departure.arrival_airport = resource_returning_flight['ArrivalAirport']
          departure.arrival_airport_code = resource_returning_flight['ArrivalAirportCode']
          departure.flight_number = resource_returning_flight['FlightNumber']
          departure.booking_class = resource_returning_flight['BookingClass']
          flight.returning_flights << departure
        end
        if params && data

          flight.booking_uri = {:url=>'http://rez.pricetravel.com/more-mexico-for-less/book/flight-reservation-details',
                                :params=>{'lastFlightRate'=>resource['TotalPrice'].to_f,
                                          'selectedOutboundFlight'=>flight.departure_flights.collect{|f|f.flight_number}.join('_'),
                                          'selectedReturnFlight'=>flight.returning_flights.collect{|f|f.flight_number}.join('_'),
                                          'prevSelectedOutboundFlight'=>'', 'prevSelectedReturnFlight'=>'',
                                          '_sHidden'=>['', ''], '_sInput'=>['', ''], 'calDeparturehdnDate'=>'',
                                          'calDeparturetxtDate'=>'mm/dd/yyyy', 'calReturnhdnDate'=>'',
                                          'calReturntxtDate'=>'mm/dd/yyyy', 'ddownAdultos'=>params['search-adults'],
                                          'ddownMenores'=>params['search-kids'],
                                          'ddownSeniors'=>'0',
                                          'keyWordId'=>'0',
                                          'keyWordTable'=>'', 'URI'=>'',
                                          'Display'=>'', 'hdnMinorAge1Package'=>'',
                                          'hdnMinorAge2Package'=>'', 'hdnMinorAge3Package'=>'',
                                          'hdnMinorAge4Package'=>'', 'hdnMinorAge5Package'=>'',
                                          'hdnMinorAgesPackage'=>'',
                                          'Rooms'=>'1',
                                          'CheckIn'=>data['departureDate'],
                                          'CheckOut'=>data['arrivalDate'],
                                          'Adults'=>params['search-adults'],
                                          'Kids'=>params['search-kids'],
                                          'AgeKids'=>data['childAges'].join(','),
                                          'Infants'=>'0',
                                          'AgeInfants'=>'',
                                          'Seniors'=>'0',
                                          'PackageType'=>'0',
                                          'CheckInWasModified'=>'False',
                                          'CheckInWasModifiedFromTransport'=>'False',
                                          'checkInWasModifiedFromUser'=>'False',
                                          'room0.Adults'=>params['search-adults'],
                                          'room0.Kids'=>params['search-kids'],
                                          'room0.Seniors'=>'0', 'room0.Infants'=>'0',
                                          'room0.AgeKids'=>data['childAges'].join(','),
                                          'room0.AgeInfants'=>'', 'HasTour'=>'false',
                                          'HasTourTransfer'=>'false', 'selectedFilter'=>'',
                                          'tripMode'=>data['isRoundTrip'] ? 'RoundTrip' : 'One Way',
                                          'tripCabin'=>'',
                                          'startingFromAirport'=>flight.departure_flights.first.departure_airport_code,
                                          'startingFromDateTime'=>flight.departure_flights.first.departure_date_time.strftime('%F'),
                                          'startingFromTime'=>'Anytime',
                                          'returningFromAirport'=>data['isRoundTrip'] ? flight.returning_flights.first.departure_airport_code : '',
                                          'returningFromDateTime'=>data['isRoundTrip'] ? flight.returning_flights.first.departure_date_time.strftime('%F') : '',
                                          'returningFromTime'=>'Anytime', 'nonStopOnly'=>'False', 'QuoteFlight'=>'false', 'isPackage'=>'False', 'IdAgent'=>'0',
                                          'IdAgentcall'=>'0', 'OriginAirportCodes'=>flight.departure_flights.first.departure_airport_code,
                                          'ArrivalAirportCodes'=>data['isRoundTrip'] ? flight.returning_flights.first.departure_airport_code : '',
                                          'SelectedFlights'=>[flight.departure_flights.collect{|f|f.flight_number}.join('_'), flight.returning_flights.collect{|f|f.flight_number}.join('_')].join(',')},
                                :method=>:post}

          flight.same_booking_uri = ApplicationController.helpers.list_item_booking_uri(flight.booking_uri, flight.api[:name], flight.prices[:price_travel])
          flight.booking_uri = ApplicationController.helpers.item_booking_uri(flight.booking_uri)


        end


        flights << flight
      end
      flights
    end

    def self.prepare_for_flights(departure_airport, arrival_airport, params)
      p = {}
      p['language'] = LANGUAGES[(params['locale'] || I18n.locale).to_sym]
      p['currency'] = Spree::Config.currency
      p['isRoundTrip'] = params['search-flight-type'] == 'roundtrip' #true o false
      p['adults'] = params['search-adults'].to_i
      p['childAges'] = [7] * params['search-kids'].to_i
      #p['departurePlaceId'] = departure_id
      #p['departurePlaceType'] = 3
      p['departureAirportCode'] = departure_airport.iata
      p['departureDate'] = Date.strptime(params['search-departing-date'], '%m/%d/%Y').to_s
      #p['departureTime']
      #p['arrivalPlaceId'] = arrival_id
      #p['arrivalPlaceType'] = 3
      p['arrivalAirportCode'] = arrival_airport.iata
      p['arrivalDate'] = p['isRoundTrip'] ? Date.strptime(params['search-returning-date'], '%m/%d/%Y').to_s : p['departureDate']
      #p['arrivalTime']
      p
    end


  end
end
