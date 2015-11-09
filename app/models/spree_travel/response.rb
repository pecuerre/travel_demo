module SpreeTravel
  class Response < Master::Response

    def self.empty_destination
      SpreeTravel::Response.new([], ['Destination not found.'])
    end

    def self.not_enough_info_for_hotels
      SpreeTravel::Response.new([], ['There is not enough information to verify availability of hotels.'])
    end

    def self.not_enough_info_for_flights
      SpreeTravel::Response.new([], ['There is not enough information to verify availability of flights.'])
    end

    def self.invalid_airport
      Response.new([], ["Airport name or destination not found."])
    end
  end
end
