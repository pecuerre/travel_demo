module Expedia
  module Utils

    # Utility methods used by Expedia.
    require 'logger'
    require 'forwardable'

    extend Forwardable
    extend self

    def_delegators :logger, :debug, :info, :warn, :error, :fatal, :level, :level=

    # The Expedia logger, an instance of the standard Ruby logger, pointing to STDOUT by default.
    # In Rails projects, you can set this to Rails.logger.
    attr_accessor :logger
    self.logger = Logger.new(STDOUT)
    self.logger.level = Logger::ERROR

    # @private
    DEPRECATION_PREFIX = "EXPEDIA: [Deprecation warning] "

    # Prints a deprecation message.
    # Each individual message will only be printed once to avoid spamming.
    def deprecate(message)
      @posted_deprecations ||= []
      unless @posted_deprecations.include?(message)
        # only include each message once
        Kernel.warn("#{DEPRECATION_PREFIX}#{message}")
        @posted_deprecations << message
      end
    end

    def self.prepare_for_hotels(params)
      p = {}
      p['destinationString'] = params['search-going-to']
      p['arrivalDate'] = params['search-check-in-date']
      p['departureDate'] = params['search-check-out-date']
      p['numberOfResults'] = 100
      rooms = params['search-rooms'].to_i
      adults = params['search-adults'].to_i
      kids = params['search-kids'].to_i
      dist = Master::Utils.distribute_adults_and_kids(rooms, adults, kids)
      rooms.times do |i|
        p["room#{i+1}"] = [dist[:adults][i]] + dist[:kids][i]
        p["room#{i+1}"] = p["room#{i+1}"].join(',')
      end
      p
    end

    def self.parse_hotels(resources)
      hotels = []
      resources = [resources] if resources.is_a?(Hash)
      resources.each do |resource|
        hotel = Hotel.new
        hotel.id = resource['hotelId']
        hotel.name = resource['name']
        hotel.name_slug = normalize(hotel.name)
        hotel.description = resource['shortDescription']
        hotel.address = resource['address1']
        hotel.address_slug = normalize(hotel.address)
        hotel.city = resource['city']
        hotel.state = resource['stateProvinceCode']
        hotel.country = resource['countryCode']
        hotel.booking_uri = {:expedia => resource['deepLink']}
        hotel.image_uri = 'http://images.travelnow.com' + resource['thumbNailUrl'].sub('t.jpg','b.jpg')
        hotel.low_rate = {:expedia => resource['lowRate'].to_money.to_f}
        hotel.high_rate = {:expedia => resource['highRate'].to_money.to_f}
        #hotel.chain =
        hotel.rating = resource['hotelRating'].to_f
        hotel.latitude = resource['latitude']
        hotel.longitude = resource['longitude']
        hotel.prices = hotel.low_rate
        hotel.api = :expedia
        hotels << hotel
      end
      hotels
    end

    def self.normalize(phrase)
      phrase = phrase.gsub('&amp','&')
      phrase.gsub!('&;','&')
      Master::Match.normalize(phrase)
    end
  end
end