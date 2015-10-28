module Aeromexico
  class Utils
    CURRENCIES = {
        'USD' => 'US'
    }

    LANGUAGES = {
        :en => 'ING',
        :es => 'ESP'
    }

    def self.prepare_for_flights(departure_airport, arrival_airport, params)

      p = {}
      p['origin'] = departure_airport.iata
      p['destination'] = arrival_airport.iata
      p['departuredate'] = Date.strptime(params['search-departing-date'], '%m/%d/%Y').strftime('%Y-%m-%d')
      p['returndate'] = Date.strptime(params['search-returning-date'], '%m/%d/%Y').strftime('%Y-%m-%d')
      p['passengercount'] = params['search-adults'].to_i + (params['search-kids'].blank? ? 0 : params['search-kids'].to_i)
      p['onlineitinerariesonly'] = 'N'
      p['limit'] = 10
      p['offset'] = 1
      p['eticketsonly'] = 'N'
      p['sortby'] = 'totalfare'
      p['order'] = 'asc'
      p['sortby2'] = 'departuretime'
      p['order2'] = 'asc'
      p['pointofsalecountry'] = 'US'


      # https://api.test.sabre.com/v1/shop/flights
      # ?origin=JFK
      # &destination=LAX
      # &departuredate=2015-05-20
      # &returndate=2015-05-25
      # &onlineitinerariesonly=N
      # &limit=10
      # &offset=1
      # &eticketsonly=N
      # &sortby=totalfare
      # &order=asc
      # &sortby2=departuretime
      # &order2=asc
      # &pointofsalecountry=US

      p
    end

    def self.parse_flights(resources, params=nil, data=nil)
      flights = []
      resources['PricedItineraries'].each do |resource|

        flight = Flight.new
        # flight.id = resource['Id'].first

        flight.airline = 'Aeromexico'
        flight.prices = {:aeromexico =>resource['AirItineraryPricingInfo']['ItinTotalFare']['TotalFare']['Amount']}
        flight.api = { name: :aeromexico, string: 'Aeromexico'}
        flight.image_uri = flight.image

        resource['AirItinerary']['OriginDestinationOptions']['OriginDestinationOption'].each_with_index do |flightdata, index|
          departure = Departure.new
            departure.airline = 'Aeromexico'
            departure.duration_in_minutes = flightdata['ElapsedTime']

            departures = []
            flightdata['FlightSegment'].each do |segment|

              date_time = segment['DepartureDateTime']
              departure.departure_date_time = DateTime.strptime(date_time, '%Y-%m-%dT%H:%M:%S')
              departure.departure_airport_code = segment['DepartureAirport']['LocationCode']

              date_time = segment['ArrivalDateTime']
              departure.arrival_date_time = DateTime.strptime(date_time, '%Y-%m-%dT%H:%M:%S')
              departure.arrival_airport_code = segment['ArrivalAirport']['LocationCode']
              departure.flight_number = segment['FlightNumber']

              departures << departure

            end

            if index == 0
              flight.departure_flights = departures
            else
              flight.returning_flights = departures
            end

          end

          if params && data
            dd = Date.strptime(params['search-departing-date'], '%m/%d/%Y').strftime('%Y-%m-%d')
            rd = Date.strptime(params['search-returning-date'], '%m/%d/%Y').strftime('%Y-%m-%d')
            flight.booking_uri = {:aeromexico =>"https://booking.aeromexico.com/SSW2010/D5DE/webqtrip.html?&searchType=NORMAL&journeySpan=TR&departureDate=#{dd}&returnDate=#{rd}&origin=#{data[:origin]}&destination=#{data[:destination]}&numAdults=#{data[:passengercount]}&lang=en_US&currency=#{Spree::Config.currency}&alternativeLandingPage=AIR_SELECT_PAGE&cabin=ECONOMY"
            }
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