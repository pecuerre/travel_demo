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

    def self.parse_house(resource, params, p)
      house = House.new
      house.id = resource['id']
      house.destination = resource['destination']['name']
      house.destination_id = resource['destination']['id']
      house.main_image_uri = resource['image_cover']['path']
      house.images_uris = resource['images'].map do |image|
        image['path']
      end
      house.house_type = resource['house_type']
      house.name = resource['name']
      house.details_uri = resource['links']['self']
      house.rooms_uri = resource['links']['relationships']['rooms']['links']['related']
      house.services = resource['services'].map do |service|
        service
      end
      house.checkin_time = resource['checkin']
      house.checkout_time = resource['checkout']
      house.owner = resource['owner']
      house.rooms = resource['number_of_rooms'].to_i
      house.api = {name: :spree_travel, string: 'SpreeTravel'}
      house.availabilities = resource['availability'].each do |availability|
        house_availability = HouseAvailability.new
        house_availability.adults = availability['pax']['adults']
        house_availability.children = availability['pax']['children']
        house_availability.infants = availability['pax']['infants']
        house_availability.room_id = availability['room']['id']
        house_availability.room_name = availability['room']['name']
        house_availability.plan_id = availability['plan']['id']
        house_availability.plan_name = availability['plan']['name']
        house_availability.price = availability['price']
        house_availability.message = availability['message']
        house_availability
      end
      # house.prices = {:spree_travel => resource.price}
      # house.same_booking_uri = flight_booking_uri(resource, params)
      # house.booking_uri = flight.same_booking_uri
    end

    def self.parse_houses(resources, params, p)
      houses = []
      resources['data'].each do |resource|
        house = self.parse_house(resource, params, p)
        houses << house
      end
      house
    end

    def self.prepare_for_houses(params)
      # destination = Some Query to get holiplus destinations
      destination = 81
      p = {}
      p['apikey'] = Figaro.env.HOLIPLUS_API_KEY
      p['locale'] = LANGUAGES[(params['locale'] || I18n.locale).to_sym]
      p['destination_id'] = destination
      p['checking'] = params[:checkin].to_date.strftime("%Y-%m-%d")
      p['checkout'] = params[:checkout].to_date.strftime("%Y-%m-%d")
      p['rooms'] = (params['adults'] || '0') + "." + (params['children'] || '0') + "." + (params["infants"] || '0')
      p
    end

    def self.prepare_for_house(params)
      p = {}
      p['apikey'] = Figaro.env.HOLIPLUS_API_KEY
      p['locale'] = LANGUAGES[(params['locale'] || I18n.locale).to_sym]
      p
    end
  end
end
