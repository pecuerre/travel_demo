module SpreeTravel
  class Response < Master::Response

    def self.empty_destination
      SpreeTravel::Response.new([], ['Destination not found.'])
    end

    def self.not_enough_info
      SpreeTravel::Response.new([], ['There is not enough information to verify availability of hotels.'])
    end
  end
end
