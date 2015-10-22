module Master
  class Merge

    # aqui le damos un orden de preferencia de las OTAs por cada campo
    # por ejemplo cuando estemos mezclando 2 hotels, en el campo name, nos quedamos con el valor que viene de price_travel
    @@hotel_properties = {
      :name => [:price_travel, :expedia],
      :description => [:price_travel, :expedia],
      :address => [:price_travel, :expedia],
      :city => [:price_travel, :expedia],
      :state => [:price_travel, :expedia],
      :country => [:price_travel, :expedia],
      :image_uri => [:expedia, :price_travel],
      :chain => [:expedia, :price_travel],
      :rating => [:price_travel, :expedia],
      :latitude => [:expedia, :price_travel],
      :longitude => [:expedia, :price_travel]
    }

    @@flight_properties = {
        :airline => [:price_travel, :best_day],
        :duration_in_minutes => [:price_travel, :best_day],
        :departure_flights => [:price_travel, :best_day],
        :returning_flights => [:price_travel, :best_day],
        :image_uri => [:best_day, :price_travel]
    }

    def self.hotels_merge(hotel_1, hotel_2)
      hotel = Hotel.new
      hotel.name = best_hotel_for(hotel_1, hotel_2, :name).name
      hotel.name_slug = Match.normalize(hotel.name)
      hotel.description = best_hotel_for(hotel_1, hotel_2, :description).description
      hotel.prices = hotel_1.prices.merge(hotel_2.prices)
      hotel.api = :merged
      hotel.address = best_hotel_for(hotel_1, hotel_2, :address).address
      hotel.address_slug = Match.normalize(hotel.address)
      hotel.city = best_hotel_for(hotel_1, hotel_2, :city).city
      hotel.state = best_hotel_for(hotel_1, hotel_2, :state).state
      hotel.country = best_hotel_for(hotel_1, hotel_2, :country).country
      hotel.booking_uri = hotel_1.booking_uri.merge(hotel_2.booking_uri)
      hotel.image_uri = best_hotel_for(hotel_1, hotel_2, :image_uri).image_uri
      hotel.low_rate = hotel_1.low_rate.merge(hotel_2.low_rate)
      hotel.high_rate = hotel_1.high_rate.merge(hotel_2.high_rate)
      hotel.chain = best_hotel_for(hotel_1, hotel_2, :chain).chain
      hotel.rating = best_hotel_for(hotel_1, hotel_2, :rating).rating
      hotel.latitude = best_hotel_for(hotel_1, hotel_2, :latitude).latitude
      hotel.longitude = best_hotel_for(hotel_1, hotel_2, :longitude).longitude
      hotel
    end

    def self.best_hotel_for(hotel_1, hotel_2, property)
      return hotel_1 if hotel_1.api == :merged
      return hotel_2 if hotel_2.api == :merged
      @@hotel_properties[property].each do |api_preferred|
        hotel = [hotel_1, hotel_2].find{|h| h.api == api_preferred}
        return hotel if hotel
      end
    end

    def self.flights_merge(flight_1, flight_2)
      flight = Flight.new
      flight.airline = best_flight_for(flight_1, flight_2, :airline).airline
      flight.duration_in_minutes = best_flight_for(flight_1, flight_2, :duration_in_minutes).duration_in_minutes
      flight.image_uri = best_flight_for(flight_1, flight_2, :image_uri).image_uri
      flight.departure_flights = best_flight_for(flight_1, flight_2, :departure_flights).departure_flights
      flight.returning_flights = best_flight_for(flight_1, flight_2, :returning_flights).returning_flights
      flight.prices = flight_1.prices.merge(flight_2.prices)
      flight.booking_uri = flight_1.booking_uri.merge(flight_2.booking_uri)
      flight.api = :merged
      flight
    end

    def self.best_flight_for(flight_1, flight_2, property)
      return flight_1 if flight_1.api == :merged
      return flight_2 if flight_2.api == :merged
      @@flight_properties[property].each do |api_preferred|
        flight = [flight_1, flight_2].find{|h| h.api == api_preferred}
        return flight if flight
      end
    end

  end
end