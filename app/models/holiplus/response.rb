module Holiplus
  class Response < Master::Response

    def self.empty_destination
      Holiplus::Response.new([], ['Destination not found.'])
    end

    def self.not_enough_info_for_hotels
      Holiplus::Response.new([], ['There is not enough information to verify availability of hotels.'])
    end

    def self.not_enough_info_for_flights
      Holiplus::Response.new([], ['There is not enough information to verify availability of flights.'])
    end

    def self.invalid_airport
      Response.new([], ["Airport name or destination not found."])
    end
  end
end
