module SpreeTravel
  class Utils

    LANGUAGES = {
        :en => 'en-US',
        :es => 'es-MX'
    }

    def self.params_for_hotels?(params)
      return false if params['search-going-to'].empty?
      return false if params['search-check-in-date'].empty?
      return false if params['search-check-out-date'].empty?
      true
    end

    def self.params_for_flights?(params)
      return false if params['search-flight-type'].empty?
      return false if params['search-flying-from'].empty?
      return false if params['search-flying-to'].empty?
      return false if params['search-departing-date'].empty?
      return false if params['search-flight-type'] == 'Roundtrip' && params['search-returning-date'].empty?
      true
    end

    def self.normalize(phrase)
      Master::Match.normalize(phrase)
    end

    def self.hotel_booking_uri(product, params)

    end

    def self.flight_booking_uri(product, params)

    end

    def self.parse_hotels(products, params)
      hotels = []
      products.each do |product|
        #product = Spree::Product.new
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
        hotel.image_uri = (product.images.first.attachment.url rescue nil)
        # hotel.low_rate = {}
        # hotel.high_rate = {}
        # hotel.chain = product.chain
        # hotel.rating = product.rating
        hotel.reviews = 'No'
        # hotel.latitude =
        # hotel.longitude =
        hotel.prices = {:spree_travel => product.price }
        hotel.api = {name: :spree_travel, string: 'SpreeTravel'}
        hotel.room_type = product.variants.first.name
        hotel.booking_uri = hotel_booking_uri(product, params)
        # hotel.same_booking_uri = hotel.booking_uri
        hotels << hotel
      end
      hotels
    end

    def self.parse_flights(products, params)
      flights = []
      products.each do |resource|
        rate = resource.rates.first
        flight = Flight.new
        flight.name = resource.name
        # flight.airline = resource.airline
        # flight.duration_in_minutes = resource.duration
        flight.prices = {:spree_travel => resource.price}
        flight.api = {name: :spree_travel, string: 'SpreeTravel'}
        flight.image_uri =  (resource.images.first.attachment.url rescue nil)

        flight.departure_flights = []
        departure = Departure.new
        # departure.airline = resource.airline
        departure.departure_date_time = rate.get_persisted_option_value(:take_off_time).to_time
        departure.arrival_date_time = rate.get_persisted_option_value(:landing_time).to_time
        departure.duration_in_minutes = departure.arrival_date_time - departure.departure_date_time
        # departure.terminal = resource.terminal
        departure.departure_airport = rate.get_persisted_option_value(:origin)
        # departure.departure_airport_code = resourse.departure_airport_code
        departure.arrival_airport = rate.get_persisted_option_value(:destination)
        # departure.arrival_airport_code = resourse.arrival_airport_code
        departure.flight_number = resource.name
        # departure.booking_class = resource.booking_class
        flight.departure_flights << departure

        flight.same_booking_uri = flight_booking_uri(resource, params)
        flight.booking_uri = flight.same_booking_uri
        flights << flight
      end
      flights
    end

    def self.parse_houses(products, params, p)
      houses = []
      products.each do |resource|
        # rate = resource.rates.first
        house = House.new
        house.id = resource['id']
        house.destination = resource['destination']['name']
        house.image_uri = resource['image_cover']['path']
        house.house_type = resource['house_type']
        house.name = resource['name']
        house.details_uri = resource['links']['self']
        # NOTE: there are some info about relationships that is not here
        # house.prices = {:spree_travel => resource.price}
        house.api = {name: :spree_travel, string: 'SpreeTravel'}
        # flight.same_booking_uri = flight_booking_uri(resource, params)
        # flight.booking_uri = flight.same_booking_uri
        houses << house
      end
      house
    end

    def self.prepare_for_houses(params)
      p = {}
      p['apikey'] = Figaro.env.HOLIPLUS_API_KEY
      p['locale'] = LANGUAGES[(params['locale'] || I18n.locale).to_sym]
      p
    end
  end
end
